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
  };
}
