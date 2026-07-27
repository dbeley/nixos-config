{ pkgs, ... }:
{
  home.packages = [ pkgs.thunderbird ];

  # Enable native Wayland support under niri/sway
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
