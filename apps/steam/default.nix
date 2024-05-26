{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };
}
