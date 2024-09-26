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
        p = "preview-tui";
        # Open in helix
        h = "-!hx \\$nnn*";
        # Open in editor with admin rights
        s = "-!sudo -e \\$nnn*";
        # Open folder images recursively in a sequential order
        g = "-!fd -e png -e jpg -X eza --sort newest | imv";
        # Open folder images recursively in a random order
        r = "-!fd -e png -e jpg | shuf | imv";
        x = "togglex";
      };
      src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v5.0";
          sha256 = "sha256-HShHSjqD0zeE1/St1Y2dUeHfac6HQnPFfjmFvSuEXUA=";
        })
        + "/plugins";
    };
  };
}
