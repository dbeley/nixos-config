{ user, pkgs, ... }:
{
  home.packages = with pkgs; [ mpc-cli ];
  # home.file = {
  #   "scripts/mpdnotify.conf".text = ''
  #     MUSIC_DIR="~/nfs/WDC14/Musique"
  #     TEMP_COVER="/tmp/mpdnotify.png"
  #     COVER_SIZE="125x125"
  #     '';
  #   };
  services.mpd = {
    enable = true;
    musicDirectory = /home/${user}/nfs/WDC14/Musique;
    playlistDirectory = /home/${user}/.config/mpd/playlists;
    extraConfig = ''
      max_output_buffer_size "32768"
      max_playlist_length "50000"
      audio_output {
        type "pipewire"
        name "pipewire"
      }
      audio_output {
        type   "fifo"
        name   "Visualizer feed"
        path   "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };
  programs.ncmpcpp = {
    enable = true;
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "ellipse";
      progressbar_look = "─╼ ";
      # execute_on_song_change = "./~/scripts/mpdnotify.sh";
      playlist_separate_albums = "yes";
      playlist_display_mode = "classic";
      centered_cursor = "yes";
      user_interface = "alternative";
      media_library_primary_tag = "album_artist";
      header_visibility = "no";
      statusbar_visibility = "yes";
      titles_visibility = "no";
      display_bitrate = "yes";
      external_editor = "nvim";
    };
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "ctrl-u";
        command = "page_up";
      }
      {
        key = "ctrl-d";
        command = "page_down";
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
      {
        key = "g";
        command = "move_home";
      }
      {
        key = "G";
        command = "move_end";
      }
      {
        key = "m";
        command = "move_selected_items_down";
      }
      {
        key = "M";
        command = "move_selected_items_up";
      }
    ];
  };
}
