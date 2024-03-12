{ pkgs, ... }: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand =
      "fd --type file --ignore-case --hidden --follow --exclude .git";
    fileWidgetCommand =
      "fd --type file --ignore-case --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --ignore-case --hidden -t d";
    tmux.enableShellIntegration = true;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      ls = "eza --icons --group-directories-first -s Name";
      l = "eza --icons --group-directories-first -s Name";
      ll =
        "eza -1lh --icons --group-directories-first -s Name --time-style long-iso";
      la =
        "eza -1lah --icons --group-directories-first -s Name --time-style long-iso";
      gd = "git diff";
      gs = "git status";
      cpr = "rsync -azvhP --stats --inplace --zc=zstd --zl=3";
      mpv720 = ''
        mpv --ytdl-format="(bestvideo[height<=720]+bestaudio)[ext=webm]/bestvideo[height<=720]+bestaudio/best[height<=720]/bestvideo+bestaudio/best" '';
      mpv1080 = ''
        mpv --ytdl-format="(bestvideo[height<=1080]+bestaudio)[ext=webm]/bestvideo[height<=1080]+bestaudio/best[height<=1080]/bestvideo+bestaudio/best" '';
      meteo = "curl -H 'Accept-Language: fr' wttr.in";
      bal = "ledger -f ledger.ledger balance --depth 1";
      fiowrite =
        "fio --rw=write --bs=4k --size=5G --name=seqwrite --ioengine=posixaio --runtime=60 --end_fsync=1";
      fioread =
        "fio --rw=read --bs=4k --size=5G --name=seqread --ioengine=posixaio --runtime=60 --end_fsync=1";
      fiorandwrite =
        "fio --rw=randwrite --bs=4k --size=5G --name=randwrite --ioengine=posixaio --runtime=60 --end_fsync=1";
      fiorandread =
        "fio --rw=randread --bs=4k --size=5G --name=randread --ioengine=posixaio --runtime=60 --end_fsync=1";
      lzg = "lazygit";
    };

    shellInit = ''
      set -g theme_display_vi no
      set -g theme_display_date no
      set -g theme_nerd_fonts yes
      set -g theme_powerline_fonts yes
      set -g theme_color_scheme dark
      set -x VIRTUAL_ENV_DISABLE_PROMPT 1
      set -x EDITOR "kak"
      set -x IMG_VIEWER swayimg

      if test -e ~/.config/wpg/sequences
        cat ~/.config/wpg/sequences
      end

      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
      if test -n "$DESKTOP_SESSION" | test -n "$WAYLAND_DISPLAY"
        set (gnome-keyring-daemon --start | string split "=")
      end

      direnv hook fish | source
    '';
    loginShellInit = ''
      if test (tty) = /dev/tty1
        if type -q sway
          exec sway
        else if type -q Hyprland
          exec ~/.local/bin/wrappedhl
        else
          XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
        end
      end
    '';
    functions = {
      wav2flac = ''
        set ORIGINAL_SIZE (du -hs | cut -f1)

        fd -e wav -x ffmpeg -i "{}" -loglevel quiet -stats "{.}.flac"
        fd -e wav -X rm -I

        set NEW_SIZE (du -hs | cut -f1)

        echo "Done. Reduced file size from $ORIGINAL_SIZE to $NEW_SIZE"
      '';
      convert2opus = ''
        set ORIGINAL_SIZE (du -hs | cut -f1)

        fd -e wav -e flac -x ffmpeg -i "{}" -c:a libopus -b:a 128K -loglevel quiet -stats "{.}.opus"
        fd -e wav -e flac -X rm -I

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
    };

    plugins = [{
      name = "bobthefish";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-bobthefish";
        rev = "05c0765c4ec4c8fee7e2d485587e033b9e4e4543";
        sha256 = "jiXzkW4H9YORR4iRNAfjlPT2jSyXQKmNx3WA+TjleE8=";
      };
    }];

    functions = { fish_greeting = ""; };
  };
}
