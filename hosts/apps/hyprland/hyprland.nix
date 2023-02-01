{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [ mako libnotify hyprpaper udiskie grim slurp pamixer ];
  home.file.".local/bin/wrappehl".source = ./wrappedhl;
  home.file = {
  "scripts".source = pkgs.fetchFromGitHub {
     owner = "dbeley";
     repo = "scripts";
     rev = "68d791b152cb553f680b533a8ce06de228a0e819";
     sha256 = "C4nR1pdZ9Qo3yClSkxvSK1f9SF6fVIWHpCbO53PtyKg=";
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
