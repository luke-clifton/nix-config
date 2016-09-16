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

    $ nix-env -iA nixos.coreEnv
    
or if you aren't on NixOS

    $ nix-env -iA nixpkgs.coreEnv

Dotfiles
========

Some of my dotfiles are included here. I manage my dotfiles in Nix
by creating an executable that I can run that will update my dotfiles
that I configure in my nix config. See [the dotfiles](./dotfiles) directory
for examples.

    $ nix-env -iA nixos.dotfiles
    $ updateDotFiles

By keeping the `updateDotFiles` executable installed, any derivations
referenced by your dotfiles won't be garbage collected. If you do update
your nixpkgs and re-install `nixos.dotfiles` you should run `updateDotFiles`
immediately in order to avoid accidentally relying on derivations that
may be garbage collected in the near future.

`updateDotFiles` won't overwrite any customisations you may have made, and
will print out a warning if such files exist. If you want to get the files
that `updateDotFiles` is tyring to give you, simply delete the existing
files.
