{ user, ... }:
{
  stylix.targets = {
    waybar.enable = false;
    tmux.enable = false;
    fish.enable = false;
    firefox.enable = true;
    mangohud.enable = false;
    gnome.enable = true;
    nixvim.enable = false;
    hyprland.enable = true;
    firefox.profileNames = [ "${user}" ];
  };
}
