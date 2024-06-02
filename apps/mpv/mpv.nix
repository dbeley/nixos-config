{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      thumbfast
      uosc
      # sponsorblock
      # mpv-webm
    ];
  };
}
