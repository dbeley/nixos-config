{ pkgs, ... }:
{
  wallpapers = {
    "abstract-light-rays" = {
      image = pkgs.fetchurl {
        url = "https://images.unsplash.com/photo-1672491441167-1daa7c3c95a8";
        sha256 = "WoYwXx6WT+mzAmnsY+eY+eCMzf+PwMApUQuOTNaIjGE=";
      };
    };
    "blue-planet" = {
      image = pkgs.fetchurl {
        url = "https://images.unsplash.com/photo-1542052605271-43cf9ff1609f";
        sha256 = "aR1JAQLBisLuz2Gd9ARV8qW0ePQqMpUiLq7teth2p4Q=";
      };
    };
    "hk-plant" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P9162201.jpg";
        sha256 = "+l73wncx2U79NQmBzjP0yVzUENqopIFjNzfOKTBxe2Q=";
      };
      "taiwan-road" = {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/P9131591.jpg";
          sha256 = "rGs1PrdYZbtX0VrwTHPSfxNMjJ/9eVYcGpg09Jtg8Us=";
        };
      };
      "hk-buildings" = {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P1011753.jpg";
          sha256 = "MUa09MnscDNCdwYO0pnTL5FyPnXd/hXLDVqZA9oh8zw=";
        };
      };
      "hk-road" = {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P1010917.jpg";
          sha256 = "smPIXjBiSVcQiEdR1eXdIh069HQbZOWmc9uBu86VcSI=";
        };
      };
      "nyc-hearst-tower" = {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/ET312096.jpg";
          sha256 = "mJe6WUXxb2eQBe8qsdDhxbfv7mUysjsKrhKrqFEp/xc=";
        };
      };
      "nyc-425-park-avenue" = {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/ET012548.jpg";
          sha256 = "54yf34yXHRJj6pHlttoaXTXjP0AfvE8dMVyOO0ktH+g=";
        };
      };
      "purple-waves" = {
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/dbeley/nixos-config/refs/heads/main/imgs/wallpapers/9580633.jpg";
          sha256 = "Ooq+nJpzwS3f3wuio90m/4UEguD7GmGvnlCsEKjYLGE=";
        };
      };
    };
  };
  defaultWallpaper = "abstract-light-rays";
}
