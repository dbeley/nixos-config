{ pkgs, ... }:
{
  # Available scaling modes: stretch, fill, fit, center, tile
  wallpapers = {
    "abstract-light-rays" = {
      image = pkgs.fetchurl {
        url = "https://images.unsplash.com/photo-1672491441167-1daa7c3c95a8";
        sha256 = "WoYwXx6WT+mzAmnsY+eY+eCMzf+PwMApUQuOTNaIjGE=";
      };
      imageScalingMode = "fit";
    };
    "blue-planet" = {
      image = pkgs.fetchurl {
        url = "https://images.unsplash.com/photo-1542052605271-43cf9ff1609f";
        sha256 = "aR1JAQLBisLuz2Gd9ARV8qW0ePQqMpUiLq7teth2p4Q=";
      };
      imageScalingMode = "fit";
    };
    "hk-plant" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P9162201.jpg";
        sha256 = "+l73wncx2U79NQmBzjP0yVzUENqopIFjNzfOKTBxe2Q=";
      };
      imageScalingMode = "fill";
    };
    "hk-buildings" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P1011753.jpg";
        sha256 = "MUa09MnscDNCdwYO0pnTL5FyPnXd/hXLDVqZA9oh8zw=";
      };
      imageScalingMode = "fill";
    };
    "hk-road" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/HK%20P1010917.jpg";
        sha256 = "smPIXjBiSVcQiEdR1eXdIh069HQbZOWmc9uBu86VcSI=";
      };
      imageScalingMode = "fill";
    };
    "taiwan-road" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/P9131591.jpg";
        sha256 = "rGs1PrdYZbtX0VrwTHPSfxNMjJ/9eVYcGpg09Jtg8Us=";
      };
      imageScalingMode = "fill";
    };
    "taiwan-bus" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/P9040182.jpg";
        sha256 = "YRMTzAPjd+J+wq5+cBIqAioQjq79GnBjY6lyqM6jxMA=";
      };
      imageScalingMode = "fill";
    };
    "nyc-hearst-tower" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/ET312096.jpg";
        sha256 = "mJe6WUXxb2eQBe8qsdDhxbfv7mUysjsKrhKrqFEp/xc=";
      };
      imageScalingMode = "fill";
    };
    "nyc-425-park-avenue" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/photo-stream/refs/heads/master/photos/original/ET012548.jpg";
        sha256 = "54yf34yXHRJj6pHlttoaXTXjP0AfvE8dMVyOO0ktH+g=";
      };
      imageScalingMode = "fill";
    };
    "purple-waves" = {
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dbeley/nixos-config/refs/heads/main/imgs/wallpapers/9580633.jpg";
        sha256 = "Ooq+nJpzwS3f3wuio90m/4UEguD7GmGvnlCsEKjYLGE=";
      };
      imageScalingMode = "fill";
    };
  };
  defaultWallpaper = "abstract-light-rays";
}
