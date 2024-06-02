{ pkgs, ... }:
{
  stylix = {
    image = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1672491441167-1daa7c3c95a8";
      sha256 = "WoYwXx6WT+mzAmnsY+eY+eCMzf+PwMApUQuOTNaIjGE=";
    };
    # image = pkgs.fetchurl {
    #   url = "https://images.unsplash.com/photo-1542052605271-43cf9ff1609f";
    #   sha256 = "aR1JAQLBisLuz2Gd9ARV8qW0ePQqMpUiLq7teth2p4Q=";
    # };
    # image = pkgs.fetchurl {
    #   url = "https://github.com/dbeley/photo-stream/blob/master/photos/original/HK%20P9162201.jpg?raw=true";
    #   sha256 = "+l73wncx2U79NQmBzjP0yVzUENqopIFjNzfOKTBxe2Q=";
    # };

    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.eb-garamond;
        name = "EB Garamond";
      };
      sansSerif = {
        package = pkgs.overpass;
        name = "Overpass";
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; };
        name = "Iosevka Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
