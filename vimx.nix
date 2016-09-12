pkgs: with pkgs; pkgs.vim_configurable.customize {
    name = "vimx";
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [
        { name = "colors-solarized"; }
        { name = "fugitive"; }
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
}
