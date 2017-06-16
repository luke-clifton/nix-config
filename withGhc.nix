{pkgs}:
with pkgs;

writeScriptBin "ghcWith" ''
  #! ${bash}/bin/bash
  PKGS=()

  for i in "$@"
  do
    shift
    if [ "$i" = '--' ]
    then
      break
    else
      PKGS+=($i)
    fi
  done
  set -x
  PSTR="haskellPackages.ghcWithPackages (p: with p; [ ''${PKGS[*]} ])"
  if [ -n "$*" ]
  then
    exec ${nix}/bin/nix-shell -p "$PSTR" --run "$*"
  else
    exec ${nix}/bin/nix-shell -p "$PSTR"
  fi
''
