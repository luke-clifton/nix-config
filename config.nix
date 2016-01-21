{
	allowUnfree = true;

	packageOverrides = super: let self = super.pkgs; in {

		haskellPackages = super.haskellPackages.override {
			overrides = self: super: {
				hadoop-rpc = self.callPackage /home/lukec/src/hadoop-rpc {};
				hadoop-tools = self.callPackage /home/lukec/src/hadoop-tools {};
			};
		};
		gsasl = super.stdenv.lib.overrideDerivation super.gsasl (x : {
			configureFlags = "--with-gssapi-impl=mit";
			nativeBuildInputs = x.nativeBuildInputs ++ [ super.libkrb5 ];
		});

		st = super.st.override { conf = (builtins.readFile ./st/config.def.h); };
	};
}
