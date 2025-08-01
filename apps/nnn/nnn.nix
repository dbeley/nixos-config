{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;

    bookmarks = {
      h = "~";
      n = "~/Nextcloud";
      a = "~/Nextcloud/10-19_Images/11_Captures-d-écran/11.01_autoscreen";
      s = "~/Nextcloud/10-19_Images/11_Captures-d-écran";
      e = "~/nfs/Expansion/Downloads";
      t = "~/Téléchargements";
      d = "~/Documents";
      f = "~/nfs";
      m = "~/nfs/WDC14/Musique";
      r = "~/Nextcloud/20-29_Médias/20_Partitions/20.04_Real-Books";
      p = "~/Nextcloud/20-29_Médias/20_Partitions/20.05_Real-Books-Individual-Songs";
      c = "~/Nextcloud/20-29_Médias/20_Partitions/20.06_Christmas-Individual-Songs";
    };
    plugins = {
      mappings = {
        a = "autojump";
        c = "fzcd";
        f = "finder";
        v = "imgview";
        p = "preview-tui";
        # Open in helix
        h = "-!hx \\$nnn*";
        # Open in editor with admin rights
        s = "-!sudo -e \\$nnn*";
        # Open folder images recursively in a sequential order
        g = "-!fd -e png -e jpg -X eza --sort newest | swayimg";
        # Open folder images recursively in a random order
        r = "-!fd -e png -e jpg | shuf | swayimg";
        x = "togglex";
      };
      src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v5.1";
          sha256 = "17mygdwdsb49zd0w1r4injaybmwp99dhhaabj30i7aas3ca4asgv";
        })
        + "/plugins";
    };
  };
}
