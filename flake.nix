{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = inputs@{ self, nixpkgs }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [ "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix" ];
          environment = {
            enableDebugInfo = true;
            systemPackages = with pkgs; [
              ashpd-demo
              d-spy
              gdb
              binutils
              file
              glib
              htop
              less
            ];
          };
          services.xserver = {
            enable = true;
            desktopManager.pantheon = {
              enable = true;
              debug = true;
            };
          };
          users.users.test = {
            isNormalUser = true;
            uid = 1000;
            extraGroups = [ "wheel" "networkmanager" ];
            password = "test";
          };
          virtualisation = {
            qemu.options = [ "-device intel-hda -device hda-duplex" ];
            memorySize = 2048;
            diskSize = 8192;
          };
          system.stateVersion = "22.11";
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
