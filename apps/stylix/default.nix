{ pkgs, ... }:
{
  stylix = {
    enable = true;
    # abstract light rays black
    # image = pkgs.fetchurl {
    #   url = "https://images.unsplash.com/photo-1672491441167-1daa7c3c95a8";
    #   sha256 = "WoYwXx6WT+mzAmnsY+eY+eCMzf+PwMApUQuOTNaIjGE=";
    # };
    # planet-like blue paint waves
    # image = pkgs.fetchurl {
    #   url = "https://images.unsplash.com/photo-1542052605271-43cf9ff1609f";
    #   sha256 = "aR1JAQLBisLuz2Gd9ARV8qW0ePQqMpUiLq7teth2p4Q=";
    # };
    # HK plant
    # image = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P9162201.jpg";
    #   sha256 = "+l73wncx2U79NQmBzjP0yVzUENqopIFjNzfOKTBxe2Q=";
    # };
    # Taiwan road
    # image = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/P9131591.jpg";
    #   sha256 = "rGs1PrdYZbtX0VrwTHPSfxNMjJ/9eVYcGpg09Jtg8Us=";
    # };
    # HK buildings
    # image = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P1011753.jpg";
    #   sha256 = "MUa09MnscDNCdwYO0pnTL5FyPnXd/hXLDVqZA9oh8zw=";
    # };
    # HK road
    # image = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P1010917.jpg";
    #   sha256 = "smPIXjBiSVcQiEdR1eXdIh069HQbZOWmc9uBu86VcSI=";
    # };
    # NYC hearst tower
    # image = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/ET312096.jpg";
    #   sha256 = "mJe6WUXxb2eQBe8qsdDhxbfv7mUysjsKrhKrqFEp/xc=";
    # };
    # NYC 425 park avenue
    # image = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/ET012548.jpg";
    #   sha256 = "54yf34yXHRJj6pHlttoaXTXjP0AfvE8dMVyOO0ktH+g=";
    # };
    # Purple waves
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/dbeley/nixos-config/refs/heads/main/imgs/wallpapers/9580633.jpg";
      sha256 = "Ooq+nJpzwS3f3wuio90m/4UEguD7GmGvnlCsEKjYLGE=";
    };
    imageScalingMode = "fit";

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
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };
}
