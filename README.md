Usage
=====

After installing [Nix](https://nixos.org/nix/) or
[NixOS](https://nixos.org/) checkout this repository as your
`~/.nixpkgs` directory. We provide a few different sets of packages
depending on your needs.

|       |Command Line  |X           |
|-------|--------------|------------|
|small  |`coreEnv`     |`coreXEnv`  |
|large  |`baseEnv`     |`baseXEnv`  |

The "small" packages are designed to have a minimal dependency tree, and
be quick to install, even from source. The "large" packages ignore this
requirement, and may take a long time to install.

You can install these packages using the command

    nix-env -iA nixos.coreEnv
    
or if you aren't on NixOS

    nix-env -iA nixpkgs.coreEnv


