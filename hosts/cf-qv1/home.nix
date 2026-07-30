{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # audacity
    beets
    feishin
    losslesscut
    # musescore
    nautilus
    shotcut
    papers
    python3Packages.subliminal
  ];

  # CF-QV1 specific settings
  # 3880x1920 screen needs higher scaling and font size
  # Use extraConfig for output overrides since they're in _children for toKDL compatibility
  wayland.windowManager.niri.extraConfig = ''
    output "DP-4" {
      mode "2560x1440@143.912"
      position x=1440 y=0
    }
    output "eDP-1" {
      scale 2.0
      position x=0 y=0
    }
  '';
  programs.hyprlock.settings.label.font_size = lib.mkForce 100;
  # Increase trackpad sensitivity for the smaller trackpad
  wayland.windowManager.niri.settings.input.touchpad = {
    "accel-speed" = 0.6;
    "accel-profile" = "flat";
  };
}
