{
    packageOverrides = pkgs: rec {

        # A more complete editing experience.
        vimx = pkgs.vim_configurable.customize {
            name = "vimx";
            vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
            vimrcConfig.vam.pluginDictionaries = [
                { name = "fugitive"; }
            ];
        };

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
                file
                gist
                git
                imagemagick
                ired
                moreutils
                netcat-openbsd
                nix-repl
                nq
                pv
                slmenu
                st
                vim
                weechat
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
                vimx
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
