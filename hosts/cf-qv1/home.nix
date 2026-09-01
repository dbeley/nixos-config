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

  programs.hyprlock.settings.label.font_size = lib.mkForce 100;
  # Increase trackpad sensitivity for the smaller trackpad
  wayland.windowManager.niri.settings.input.touchpad = {
    "accel-speed" = 0.6;
    "accel-profile" = "flat";
  };
}
