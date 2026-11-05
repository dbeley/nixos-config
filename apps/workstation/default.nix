{ pkgs, ... }:
{
  console.keyMap = "us-acentos";
  networking.extraHosts = ''
    0.0.0.0 modules-cdn.eac-prod.on.epicgames.com
  '';
  hardware.graphics = {
    enable = true;
    enable32Bit = pkgs.stdenv.hostPlatform.isx86_64;
  };
  services = {
    fwupd.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = pkgs.stdenv.hostPlatform.isx86_64;
      pulse.enable = true;
    };
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
    };
  };
  systemd.oomd.enable = false;
  security.rtkit.enable = true;
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
    ];
    fontconfig.enable = true;
  };
}
