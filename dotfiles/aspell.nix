pkgs :
pkgs.writeText "aspell.conf" ''
dict-dir ${pkgs.aspellDicts.en}/lib/aspell/
''
