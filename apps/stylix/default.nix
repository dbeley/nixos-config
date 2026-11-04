{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.my.stylix;
  wallpaperCatalog = import ./wallpapers.nix { inherit pkgs; };
  wallpaperNames = lib.attrNames wallpaperCatalog.wallpapers;

  iosevkaNerdMono = pkgs.runCommand "iosevka-nerd-font-mono" { } ''
    mkdir -p $out/share/fonts/truetype/NerdFonts/Iosevka
    for style in Regular Bold Italic BoldItalic; do
      cp "${pkgs.nerd-fonts.iosevka}/share/fonts/truetype/NerdFonts/Iosevka/IosevkaNerdFontMono-$style.ttf" \
        "$out/share/fonts/truetype/NerdFonts/Iosevka/"
    done
  '';
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  options.my.stylix = {
    wallpaper = lib.mkOption {
      type = lib.types.enum wallpaperNames;
      default = wallpaperCatalog.defaultWallpaper;
      description = "Name of the wallpaper to use";
      example = "purple-waves";
    };
  };
  config.stylix = {
    enable = true;
    inherit (wallpaperCatalog.wallpapers.${cfg.wallpaper})
      image
      imageScalingMode
      ;

    polarity = "dark";
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      popups = 0.5;
      terminal = 0.75;
    };
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
        package = iosevkaNerdMono;
        name = "Iosevka Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
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
