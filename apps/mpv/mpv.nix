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
    bindings = {
      r = "cycle_values video-rotate 90 180 270 0";
    };
  };
}
