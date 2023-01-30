{ pkgs, ... }:

{
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
      vim = "nvim";
      ls = "exa";
      l = "exa";
      ll = "exa -lh";
      la = "exa -lah";
      gd = "git diff";
      gs = "git status";
      cpr = "rsync -azvhP --stats --inplace --zc=zstd --zl=3";
      mpv720 = "mpv --ytdl-format=\"(bestvideo[height<=720]+bestaudio)[ext=webm]/bestvideo[height<=720]+bestaudio/best[height<=720]/bestvideo+bestaudio/best\" ";
      mpv1080 = "mpv --ytdl-format=\"(bestvideo[height<=1080]+bestaudio)[ext=webm]/bestvideo[height<=1080]+bestaudio/best[height<=1080]/bestvideo+bestaudio/best\" ";
      meteo = "curl -H 'Accept-Language: fr' wttr.in";
      bal = "ledger -f ledger.ledger balance --depth 1";
      };

    shellInit = ''
      set -g theme_display_vi no
      set -g theme_display_date no
      set -g theme_nerd_fonts yes
      set -g theme_powerline_fonts yes
      set -g theme_color_scheme dark
      set -x VIRTUAL_ENV_DISABLE_PROMPT 1
      set -x PAGER "bat"
      set -x MANPAGER "bat"
      set -x IMG_VIEWER imv
      set TERM "rxvt"

      if test -e ~/.config/wpg/sequences
        cat ~/.config/wpg/sequences
      end
      '';
    loginShellInit = ''
      if test (tty) = /dev/tty1
        exec ~/.local/bin/wrappehl
      end
        '';

    plugins = [
      {
      name="z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
        sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
      };
     }
     {
      name="bobthefish";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-bobthefish";
        rev = "2dcfcab653ae69ae95ab57217fe64c97ae05d8de";
        sha256 = "jBbm0wTNZ7jSoGFxRkTz96QHpc5ViAw9RGsRBkCQEIU=";
      };
     }
     # {
     #  name="fzf.fish";
     #  src = pkgs.fetchFromGitHub {
     #    owner = "PatrickF1";
     #    repo = "fzf.fish";
     #    rev = "63c8f8e65761295da51029c5b6c9e601571837a1";
     #    sha256 = "i9FcuQdmNlJnMWQp7myF3N0tMD/2I0CaMs/PlD8o1gw=";
     #  };
     # }
    ];
  };
}
