{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    systemdTargets = [ "graphical-session.target" ];
    timeouts = [
      {
        timeout = 900;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s && ${pkgs.brightnessctl}/bin/brightnessctl s 5%";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 1800;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = {
      "before-sleep" = "${pkgs.procps}/bin/pgrep -x hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
      "lock" = "${pkgs.procps}/bin/pgrep -x hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
    };
  };
}
