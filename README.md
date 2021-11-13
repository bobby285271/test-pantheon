# test-pantheon

Try Pantheon desktop environment with a virtual machine:

```ShellSession
$ nix --experimental-features "nix-command flakes" run github:bobby285271/test-pantheon
```

If you want to test a specific pull request, use:

```ShellSession
$ nix --experimental-features "nix-command flakes" run github:bobby285271/test-pantheon --override-input nixpkgs github:NixOS/nixpkgs/pull/${pr_number}/head
```

Login with username and password `test`.
