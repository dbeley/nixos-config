{ pkgs, lib, ... }:

{
  programs.mpd = {
    enable = true;
    musicDirectory = "~/nfs/WDC14/Musique" ;
    playlistDirectory = "~/.config/mpd/playlists" ;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipewire"
      }
    '';
  };
  programs.ncmpcpp = {
    enable = true;
    settings = {
      prograssbar_look = "─╼ ";
    };
  };
}
