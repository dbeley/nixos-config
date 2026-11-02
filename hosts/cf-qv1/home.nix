{
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

  # Increase trackpad sensitivity for the smaller trackpad
  wayland.windowManager.niri.settings.input.touchpad = {
    "accel-speed" = 0.6;
    "accel-profile" = "flat";
  };
}
