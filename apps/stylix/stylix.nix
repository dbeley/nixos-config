{ pkgs, ... }:
{
  stylix = {
    image = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1672491441167-1daa7c3c95a8";
      sha256 = "WoYwXx6WT+mzAmnsY+eY+eCMzf+PwMApUQuOTNaIjGE=";
    };
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
        name = "Noti Color Emoji";
      };
    };
  };  
}
