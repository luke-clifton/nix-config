pkgs :
let
  dunstConf = pkgs.writeText "dunstrc" ''
    [global]
      font = Monospace 12
      allow_markup = no
      sort = yes
      indicate_hidden = yes
      alignment = left
      bounce_freq = 0
      show_age_threshold = 60
      ignore_newline = no
      geometry = "500x5-30+20"
      shrink = no
      transparency = 0
      idle_threshold = 120
      monitor = 0
      follow = keyboard
      sticky_history = yes
      history_length = 20
      show_indicators = yes
      line_height = 0
      separator_height = 2
      padding = 8
      horizontal_padding = 8
      separator_color = frame
      startup_notification = false
      dmenu = ${pkgs.dmenu}/bin/dmenu -p dunst:
      browser = ${pkgs.surf}
      icon_position = off
    [frame]
      width = 3
      color = "#aaaaaa"
    [shortcuts]
      close = ctrl+space
      close_all = ctrl+shift+space
      history = ctrl+grave
      context = ctrl+shift+period
  '';
in
  pkgs.writeText "xinitrc" ''
    ${pkgs.dunst}/bin/dunst -config ${dunstConf} &
  ''
