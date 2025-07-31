{ pkgs, user, ... }:
{
  home.packages = with pkgs; [ nvd ];
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type file --ignore-case --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type file --ignore-case --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --ignore-case --hidden -t d";
    tmux.enableShellIntegration = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons --group-directories-first -s Name";
      l = "eza --icons --group-directories-first -s Name";
      ll = "eza -1lh --icons --group-directories-first -s Name --time-style long-iso";
      la = "eza -1lah --icons --group-directories-first -s Name --time-style long-iso";
      gd = "git diff";
      gds = "git diff --staged";
      gs = "git status";
      gss = "git status --staged";
      gc = "git commit -m";
      gca = "git commit --amend";
      gpf = "git push -f";
      gcb = "git switch -c";
      gbc = "git switch -c";
      cpr = "rsync -azvhP --stats --inplace --zc=zstd --zl=3";
      mpv720 = ''mpv --ytdl-format="(bestvideo[height<=720]+bestaudio)[ext=webm]/bestvideo[height<=720]+bestaudio/best[height<=720]/bestvideo+bestaudio/best" '';
      mpv1080 = ''mpv --ytdl-format="(bestvideo[height<=1080]+bestaudio)[ext=webm]/bestvideo[height<=1080]+bestaudio/best[height<=1080]/bestvideo+bestaudio/best" '';
      meteo = "curl -H 'Accept-Language: fr' wttr.in";
      bal = "ledger -f ledger.ledger balance --depth 1";
      fiowrite = "fio --rw=write --bs=4k --size=5G --name=seqwrite --ioengine=posixaio --runtime=60 --end_fsync=1";
      fioread = "fio --rw=read --bs=4k --size=5G --name=seqread --ioengine=posixaio --runtime=60 --end_fsync=1";
      fiorandwrite = "fio --rw=randwrite --bs=4k --size=5G --name=randwrite --ioengine=posixaio --runtime=60 --end_fsync=1";
      fiorandread = "fio --rw=randread --bs=4k --size=5G --name=randread --ioengine=posixaio --runtime=60 --end_fsync=1";
      lzg = "lazygit";
      impermanence_new_files = "sudo fd --one-file-system --base-directory / --type f --hidden --exclude \"{tmp,etc/passwd}\"";
    };

    shellInit = ''
      set -g theme_display_vi no
      set -g theme_display_date no
      set -g theme_nerd_fonts yes
      set -g theme_powerline_fonts yes
      set -g theme_color_scheme dark
      set -x VIRTUAL_ENV_DISABLE_PROMPT 1
      set -x EDITOR hx
      set -x IMG_VIEWER swayimg
      set -x NNN_FIFO /tmp/nnn.fifo
    '';
    loginShellInit = ''
      if test (tty) = /dev/tty1
        if type -q sway
          exec sway
        else if type -q niri-session
          exec niri-session
        else if type -q Hyprland
          exec /home/${user}/.local/bin/wrappedhl
        else
          XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
        end
      end
    '';
    functions = {
      fish_greeting = "";
      wav2flac = ''
        set ORIGINAL_SIZE (du -hs | cut -f1)

        fd -e wav -x ffmpeg -i "{}" -loglevel quiet -stats "{.}.flac"
        fd -e wav -X rm -I

        set NEW_SIZE (du -hs | cut -f1)

        echo "Done. Reduced file size from $ORIGINAL_SIZE to $NEW_SIZE"
      '';
      convert2opus = ''
        set ORIGINAL_SIZE (du -hs | cut -f1)

        fd -e wav -e flac -e ape -x ffmpeg -i "{}" -c:a libopus -b:a 128K -loglevel quiet -stats "{.}.opus"
        fd -e wav -e flac -e ape -X rm -I

        set NEW_SIZE (du -hs | cut -f1)

        echo "Done. Reduced file size from $ORIGINAL_SIZE to $NEW_SIZE"
      '';
      cdj = ''
        pushd ~/Nextcloud/*/*/$argv[1].$argv[2]*
      '';
      nixdiff = ''
        nvd diff /nix/var/nix/profiles/system-$argv[1]-link /nix/var/nix/profiles/system-$argv[2]-link
      '';
      extractzip = ''
        fd -e zip -x sh -c 'unzip -o -d "''${0%.*}" "$0"' '{}' ';'
      '';
      reduce_speed = ''
        # Check if we have both arguments
        if test (count $argv) -ne 2
          echo "Error: Need two arguments - filename and speed factor"
          echo "Usage: reduce_speed <video_file> <speed_factor>"
          return 1
        end

        set -l input_file $argv[1]
        set -l speed_factor $argv[2]

        set -l extension (string match -r '\.[^\.]*$' $input_file)
        set -l filename (string replace -r '\.[^\.]*$' "" $input_file)
        set -l output_file "$filename""_$speed_factor$extension"

        # Create filter_complex string with proper variable substitution
        set -l filter_complex "[0:v]setpts=(1/$speed_factor)*PTS[v];[0:a]atempo=$speed_factor""[a]"

        # Run ffmpeg command with the pre-formatted filter string
        ffmpeg -i $input_file \
               -filter_complex "$filter_complex" \
               -map "[v]" -map "[a]" \
               $output_file
      '';
      youtube_short = ''
        if test (count $argv) -ne 1
          echo "Error: Need one argument - filename"
          echo "Usage: youtube_short <video_file>"
          return 1
        end
        set -l input_file $argv[1]
        set -l extension (string match -r '\.[^\.]*$' $input_file)
        set -l filename (string replace -r '\.[^\.]*$' "" $input_file)
        set -l output_file "$filename""_short$extension"
        ffmpeg -i $input_file -t 60 -vf "
        scale=w=1080:h=1920:force_original_aspect_ratio=increase,
        crop=1080:1920
        " -c:v libx264 -c:a aac -preset medium -crf 23 -maxrate 5M -bufsize 10M $output_file
      '';
      mpd_pick = ''
        set choice (printf "🎵 Play song\n➕ Queue song\n💿 Queue album" | fzf --prompt="Choose action: ")

        switch $choice
            case "🎵 Play song"
                mpc listall | fzf --cycle --prompt="🎵 Play song: " | read -l s
                and mpc add "$s"
                and mpc play (mpc playlist | wc -l)

            case "➕ Queue song"
                mpc listall | fzf --cycle --prompt="➕ Queue song: " | read -l s
                and mpc add "$s"

            case "💿 Queue album"
                set album (mpc list album | fzf --cycle --prompt="💿 Pick album to queue: ")
                test -z "$album"; and return

                set album_tracks (mpc find album "$album")
                test -z "$album_tracks"; and return

                for track in $album_tracks
                    mpc add "$track"
            end
        end
      '';
    };

    plugins = [
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "e3b4d4eafc23516e35f162686f08a42edf844e40";
          sha256 = "1q4ya4ndm7d7kk8ppzvpsxmk0gkdpaqhp4n5j0mpxq7vv6yrhwvi";
        };
      }
    ];
  };
}
