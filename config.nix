{
    # Uncomment when installing cntlm
    # allowBroken = true;
    packageOverrides = pkgs: rec {

        # A more complete editing experience, but slightly slower
        # loading speeds.
        vimx = pkgs.vim_configurable.customize {
            name = "vimx";
            vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
            vimrcConfig.vam.pluginDictionaries = [
                { name = "colors-solarized"; }
                { name = "fugitive"; }
                { name = "haskell-vim"; }
                { name = "tslime"; }
            ];
            vimrcConfig.customRC = ''
              set hidden
              set colorcolumn=80
              set backspace=2
              set autoindent
              filetype on
              filetype plugin on
              filetype indent off
              autocmd FileType haskell setlocal expandtab
              autocmd FileType haskell setlocal tabstop=4
              autocmd FileType haskell setlocal shiftwidth=4
              autocmd FileType haskell setlocal smarttab
            '';
        };

        st = pkgs.st.override {conf = (builtins.readFile ./st/config.def.h); };

        surf = pkgs.surf.override { patches = ./surf.diff; };

        gsasl = pkgs.stdenv.lib.overrideDerivation pkgs.gsasl (oldAttrs : {
                nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.krb5Full];
                configureFlags = "--with-gssapi-impl=mit";
        });

        # Build cntlm on OS X
        cntlm = with pkgs.stdenv.lib;
            overrideDerivation pkgs.cntlm (oldAttrs : {
                preConfigure = ''
                    sed -e 's/gcc/clang/' Makefile > Makefile.clang
                    sed -i 's/CSS=.*/CSS="xlc_r gcc clang"/' configure
                '';
            });

        # Small core of things I need excluding X stuff.
        coreEnv = with pkgs; buildEnv {
            name = "coreEnv";
            paths = 
                let
                    linux_only = [
                      abduco
                      dvtm
                      netcat-openbsd
                      nq
                      slmenu
                    ];
                    darwin_only = [];
                in [
                  ack
                  curl
                  entr
                  file
                  git
                  ired
                  moreutils
                  nix-repl
                  pv
                  vim
                  wget
                  which
                ]
                ++ lib.optionals (system == "x86_64-linux") linux_only
                ++ lib.optionals (system == "x86_64-darwin") darwin_only;
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
                shellcheck
                vimx
            ]
            ++ lib.optionals (system == "x86_64-linux") [ weechat ];
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
