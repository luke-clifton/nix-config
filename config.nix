{
    packageOverrides = pkgs: rec {

        # A more complete editing experience, but slightly slower
        # loading speeds.
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

        # Small core of things I need excluding X stuff.
        coreEnv = with pkgs; buildEnv {
            name = "coreEnv";
            paths = [
                ack
                curl
                entr
                file
                git
                ired
                moreutils
                netcat-openbsd
                nix-repl
                nq
                pv
                slmenu
                vim
                wget
                which
            ]
            ++ lib.optionals (system != "x86_64-darwin") [abduco dvtm];
        };

        # Some core things that I need when using X
        coreXEnv = with pkgs; buildEnv {
            name = "coreXEnv";
            paths = [
                dmenu
                st
                xclip
                xdotool
            ];
        };


        # A more complete base system that I don't want to rebuild
        # as frequently as core.
        baseEnv = with pkgs; buildEnv {
            name = "baseEnv";
            paths = [
                imagemagick
                vimx
                weechat
            ];
        };

        baseXEnv = with pkgs; buildEnv {
            name = "baseXEnv";
            paths = [
                firefox
                mpv
                surf
                tabbed
                youtube-dl  # A version without the X deps would be nice.
                zathura
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
