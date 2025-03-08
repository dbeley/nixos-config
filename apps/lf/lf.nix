{
  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    # Key mappings
    keybindings = {
      # # Standard navigation
      # "<c-f>" = "fzf_search";
      # "<c-g>" = "fzf_rg";
      # "gz" = "z";
      "<enter>" = "open";

      # Bookmarks
      "bh" = "cd ~";
      "bd" = "cd ~/Documents";
      "bn" = "cd ~/Nextcloud";
      "ba" = "cd ~/Nextcloud/10-19_Images/11_Captures-d-écran/11.01_autoscreen";
      "bs" = "cd ~/Nextcloud/10-19_Images/11_Captures-d-écran";
      "be" = "cd ~/nfs/Expansion/Downloads";
      "bt" = "cd ~/Téléchargements";
      "bm" = "cd ~/nfs/WDC14/Musique";
      "bp" = "cd ~/Nextcloud/20-29_Médias/20_Partitions/20.05_Real-Books-Individual-Songs";
      "bc" = "cd ~/Nextcloud/20-29_Médias/20_Partitions/20.06_Christmas-Individual-Songs";

      # Other mappings
      "D" = "delete";
      # "A" = "rename"; # Full rename
      # "a" = "push A<c-a>"; # Rename from beginning
      # "i" = "push A<a-b><a-b><a-f>"; # Rename before extension
      # "I" = "push A<c-a><a-b><a-b><a-f>"; # Rename from beginning before extension
      # "c" = "push :mkdir<space>";

      "sN" = ":{{ set sortby natural; set reverse!; set info; }}";
      "sS" = ":{{ set sortby size; set reverse!; set info size; }}";
      "sT" = ":{{ set sortby time; set reverse!; set info time; }}";
      "sA" = ":{{ set sortby atime; set reverse!; set info atime; }}";
      "sC" = ":{{ set sortby ctime; set reverse!; set info ctime; }}";
      "sE" = ":{{ set sortby ext; set reverse!; set info; }}";
    };
  };
}
