{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;

    bookmarks = {
      n = "~/Nextcloud";
      a = "~/Nextcloud/10-19_Images/11_Captures-d-écran/11.01_autoscreen";
      s = "~/Nextcloud/10-19_Images/11_Captures-d-écran";
      e = "~/nfs/Expansion/Downloads";
      t = "~/Téléchargements";
      d = "~/Documents";
      m = "~/nfs/WDC14/Musique";
    };
    plugins = {
      mappings = {
        a = "autojump";
        c = "fzcd";
        f = "finder";
        v = "imgview";
      };
      src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.9";
          sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
        })
        + "/plugins";
    };
  };
}
