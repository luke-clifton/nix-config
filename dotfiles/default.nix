pkgs : 
let
  lib = pkgs.lib;
  home = builtins.getEnv "HOME";
  dotfiles = {
    ".aspell.conf" = import ./aspell.nix pkgs;
    ".gitconfig" = ./gitconfig;
    ".xprofile" = import ./xprofile.nix pkgs;
    ".ghci" = pkgs.writeText "dot-ghci" ''
      :set prompt "λ "
      :set prompt2 "| "
    '';
  };

in
  pkgs.writeScriptBin "updateDotFiles" (''
    #! /usr/bin/env sh
    PATH=${pkgs.coreutils}/bin
    set -e
    update_dot() {
      local src="$1"
      local dst="$HOME/$2"
      local hsh="$HOME/.updatedot/$2"

      mkdir -p "$(dirname "$dst")"
      mkdir -p "$(dirname "$hsh")"

      if [ -f "$dst" ]
      then
        if [ -f "$hsh" ]
        then
          if md5sum --check --status "$hsh"
          then
            echo "Updating $2"
            rm "$dst"
            cat "$src" > "$dst"
            md5sum "$dst" > "$hsh"
          else
            echo "$2 has been manually edited, ignoring."
            echo "diff '$dst' '$src'"
          fi
        else
          echo "$2 was previously not under our control, ignoring."
        fi
      else
        echo "Installing $2"
        cat "$src" > "$dst"
        md5sum "$dst" > "$hsh"
      fi
    }
  ''
  + lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (name: value: "update_dot \"${value}\" \"${name}\"")
        dotfiles
      )
  )
