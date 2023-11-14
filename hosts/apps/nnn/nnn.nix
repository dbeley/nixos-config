{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;

    bookmarks = {
      n = "~/Nextcloud";
      e = "~/nfs/Expansion/Downloads";
      t = "~/Téléchargements";
      d = "~/Documents";
    };
    plugins = {
      mappings = {
        a = "autojump";
        c = "fzcd";
        f = "finder";
        v = "imgview";
      };
      src = (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.9";
          sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
        }) + "/plugins";
    };
  };
}
