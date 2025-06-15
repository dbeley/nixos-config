{ pkgs, lib, ... }:
with lib.hm.gvariant;
{
  home.packages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.no-overview
    gnome-disk-utility
  ];
  # mostly taken from https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:nocaps" ];
      sources = [
        (mkTuple [
          "xkb"
          "us+intl"
        ])
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
      clock-show-seconds = true;
      show-battery-percentage = true;
      gtk-enable-primary-paste = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      left-handed = true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-battery-timeout = 1800;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };
    "org/gnome/mutter" = {
      "experimental-features" = "['scale-monitor-framebuffer']";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "no-overview@fthx"
      ];
    };
  };
}
