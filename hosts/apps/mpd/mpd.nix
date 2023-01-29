{ user, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = /home/${user}/nfs/WDC14/Musique;
    playlistDirectory = /home/${user}/.config/mpd/playlists;
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
      progressbar_look = "─╼ ";
    };
  };
}
