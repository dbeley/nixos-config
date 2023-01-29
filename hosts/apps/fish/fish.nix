{ pkgs, ... }:

{
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
      set -x FZF_DEFAULT_COMMAND "fd --type file --ignore-case --hidden --follow --exclude .git"
      set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
      set -x FZF_ALT_C_COMMAND "fd --ignore-case --hidden -t d"
      set -x FZF_TMUX 1
      '';
    loginShellInit = ''
      if test (tty) = /dev/tty1
        exec ~/.local/bin/wrappehl
      end
        '';

    plugins = [{
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
    ];
  };
}