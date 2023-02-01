{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [ mako libnotify hyprpaper udiskie grim slurp pamixer ];
  home.file.".local/bin/wrappehl".source = ./wrappedhl;
  home.file = {
  "scripts".source = pkgs.fetchFromGitHub {
     owner = "dbeley";
     repo = "scripts";
     rev = "6a79814bc67bb115f012604b42a3e4aa42512014";
     sha256 = "/OhkStImlc7BuqvHvI/NX0djTvmYFi5GI5xtqIZ+ckk=";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    extraConfig = lib.fileContents ./hyprland.conf;
  };
}
