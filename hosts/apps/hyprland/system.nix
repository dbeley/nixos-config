
{ pkgs, ... }:

{
  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
    variables = {
      HYPRLAND_LOG_WLR = "1";
      XCURSOR_SIZE = "24";
      MOZ_ENABLE_WAYLAND = "1";
      # GTK_THEME = "FlatColor";
      # QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
