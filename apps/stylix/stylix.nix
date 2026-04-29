{ user, ... }:
{
  stylix.targets = {
    waybar.enable = false;
    tmux.enable = true;
    fish.enable = true;
    firefox = {
      enable = true;
      profileNames = [ "${user}" ];
      colorTheme.enable = false;
    };
    zen-browser = {
      enable = true;
      profileNames = [ "${user}" ];
      enableCss = false;
    };
    mangohud.enable = false;
    gnome.enable = true;
    nixvim.enable = true;
    mpv.enable = false;
  };
}
