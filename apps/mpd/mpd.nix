{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ mpc ];
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/nfs/WDC14/Musique";
    playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
    network.startWhenNeeded = true;
    extraConfig = ''
      audio_buffer_size "16384"
      buffer_before_play "25%"

      max_output_buffer_size "32768"
      max_playlist_length "50000"
      audio_output {
        type "pipewire"
        name "pipewire"
      }
    '';
  };
  /*
    programs.ncmpcpp = {
      enable = false;
      settings = {
        playlist_separate_albums = "yes";
        playlist_display_mode = "classic";
        user_interface = "alternative";
        header_visibility = "no";
        titles_visibility = "no";
        statusbar_visibility = "yes";
        progressbar_look = "─╼ ";
        display_bitrate = "yes";
        centered_cursor = "yes";
        media_library_primary_tag = "album_artist";
        media_library_albums_split_by_date = "yes";
        ignore_leading_the = "yes";
        jump_to_now_playing_song_at_start = "yes";
        cyclic_scrolling = "yes";
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
  */
}
