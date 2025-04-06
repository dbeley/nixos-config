{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "brightnessctl -s && brightnessctl s 5%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 1200;
          on-timeout = "pidof hyprlock || hyprlock";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
