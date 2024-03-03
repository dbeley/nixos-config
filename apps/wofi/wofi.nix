{ pkgs, ... }: {
  home.packages = with pkgs; [ wofi ];
  xdg.configFile."wofi/style.css".source = ./style.css;
  xdg.configFile."wofi/config".text = ''
    width=500
    mode=run
    stylesheet=style.css
    colors=~/.cache/wal/colors
    prompt=
    filter_rate=200
    insensitve=true
    gtk_dark=true
    term=foot
    layer=overlay
  '';
}
