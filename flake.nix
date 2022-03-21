{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = inputs@{ self, nixpkgs }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, config, ... }: {
          imports = [ 
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ];
          environment.enableDebugInfo = true;
          services.xserver = {
            enable = true;
            layout = "us";
            desktopManager.pantheon = {
              enable = true;
              debug = true;
            };
          };
          users = {
            mutableUsers = false;
            extraUsers.test = {
              isNormalUser = true;
              uid = 1000;
              extraGroups = [ "wheel" "networkmanager" ];
              password = "test";
            };
          };
          nixpkgs.config.allowAliases = false;
          virtualisation = {
            qemu.options = [ "-device intel-hda -device hda-duplex" ];
            memorySize = 2048;
            diskSize = 8192;
          };
        })
      ];
    };
    packages.x86_64-linux.default = self.nixosConfigurations.vm.config.system.build.vm;
    apps.x86_64-linux.default = {
      type = "app";
      program = "${self.packages.x86_64-linux.default}/bin/run-nixos-vm";
    };
  };
}
