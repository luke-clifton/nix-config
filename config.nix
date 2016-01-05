{
 packageOverrides = pkgs: rec {

  gsasl = pkgs.stdenv.lib.overrideDerivation pkgs.gsasl (x : {
    configureFlags = "--with-gssapi-impl=mit";
    nativeBuildInputs = x.nativeBuildInputs ++ [ pkgs.libkrb5 ];
  });

  st = pkgs.st.override { conf = (builtins.readFile ./st/config.def.h); };

 };
}
