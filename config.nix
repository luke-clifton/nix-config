{
    packageOverrides = pkgs: rec {

        st = pkgs.st.override {conf = (builtins.readFile ./st/config.def.h); };

        surf = pkgs.surf.override { patches = ./surf.diff; };

        gsasl = pkgs.stdenv.lib.overrideDerivation pkgs.gsasl (oldAttrs : {
                nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.krb5Full];
                configureFlags = "--with-gssapi-impl=mit";
        });

        # Small core of things I need.
        coreEnv = with pkgs; buildEnv {
            name = "coreEnv";
            paths = [
                abduco
                ack
                curl
                dmenu
                dvtm
                entr
                ired
                file
                gist
                git
                moreutils
                (neovim.override {vimAlias = true;})
                netcat-openbsd
                nix-repl
                nq
                pv
                slmenu
                st
                vis
                wget
                which
                xclip
                xdotool
                youtube-dl
                zathura
            ];
        };

        # A more complete base system that I don't want to rebuild
        # as frequently as core.
        baseEnv = with pkgs; buildEnv {
            name = "baseEnv";
            paths = [
                firefox
                mpv
                surf
                tabbed
            ];
        };

        # Stuff I need for work
        workEnv = with pkgs; buildEnv {
            name = "workEnv";
            paths = [
                cntlm
            ];
        };

    };
}
