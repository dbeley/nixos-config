{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;

    bookmarks = {
      h = "~";
      n = "~/Nextcloud";
      a = "~/Nextcloud/30-39_Images/32_Captures-d-écran/32.11_autoscreen";
      s = "~/Nextcloud/30-39_Images/32_Captures-d-écran";
      e = "~/nfs/Expansion1/Downloads";
      t = "~/Téléchargements";
      d = "~/Documents";
      f = "~/nfs";
      m = "~/nfs/WDC14/Musique";
      r = "~/Nextcloud/40-49_Médias/41_Partitions/41.14_Real-Books";
      p = "~/Nextcloud/40-49_Médias/41_Partitions/41.15_Real-Books-Individual-Songs";
      c = "~/Nextcloud/40-49_Médias/41_Partitions/41.16_Christmas-Individual-Songs";
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
        g = "-!swayimg -r -o mtime";
        G = "-!swayimg -r -o mtime --gallery";
        # Open folder images recursively in a random order
        r = "-!swayimg -r -o random";
        R = "-!swayimg -r -o random --gallery";
        x = "togglex";
      };
      src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v5.1";
          sha256 = "sha256-+2lFFBtaqRPBkEspCFtKl9fllbSR5MBB+4ks3Xh7vp4=";
        })
        + "/plugins";
    };
  };
}
