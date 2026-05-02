_: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableFishIntegration = true;

    settings = {
      mgr = {
        linemode = "size";
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        # Bookmarks
        {
          on = [
            "b"
            "h"
          ];
          run = "cd ~";
          desc = "Bookmark: home";
        }
        {
          on = [
            "b"
            "n"
          ];
          run = "cd ~/Nextcloud";
          desc = "Bookmark: Nextcloud";
        }
        {
          on = [
            "b"
            "a"
          ];
          run = "cd ~/Nextcloud/30-39_Images/32_Captures-d-écran/32.11_autoscreen";
          desc = "Bookmark: autoscreen";
        }
        {
          on = [
            "b"
            "s"
          ];
          run = "cd ~/Nextcloud/30-39_Images/32_Captures-d-écran";
          desc = "Bookmark: screenshots";
        }
        {
          on = [
            "b"
            "e"
          ];
          run = "cd ~/nfs/WDC14_2/Downloads";
          desc = "Bookmark: Downloads (nfs)";
        }
        {
          on = [
            "b"
            "t"
          ];
          run = "cd ~/Téléchargements";
          desc = "Bookmark: Téléchargements";
        }
        {
          on = [
            "b"
            "d"
          ];
          run = "cd ~/Documents";
          desc = "Bookmark: Documents";
        }
        {
          on = [
            "b"
            "f"
          ];
          run = "cd ~/nfs";
          desc = "Bookmark: nfs";
        }
        {
          on = [
            "b"
            "m"
          ];
          run = "cd ~/nfs/WDC14/Musique";
          desc = "Bookmark: Musique";
        }
        {
          on = [
            "b"
            "r"
          ];
          run = "cd ~/Nextcloud/40-49_Médias/41_Partitions/41.14_Real-Books";
          desc = "Bookmark: Real-Books";
        }
        {
          on = [
            "b"
            "p"
          ];
          run = "cd ~/Nextcloud/40-49_Médias/41_Partitions/41.15_Real-Books-Individual-Songs";
          desc = "Bookmark: Real-Books-Individual-Songs";
        }
        {
          on = [
            "b"
            "c"
          ];
          run = "cd ~/Nextcloud/40-49_Médias/41_Partitions/41.16_Christmas-Individual-Songs";
          desc = "Bookmark: Christmas-Individual-Songs";
        }
        # Image viewer (swayimg)
        {
          on = [
            "i"
            "g"
          ];
          run = "shell 'swayimg -r -o mtime \"$@\"' --orphan";
          desc = "Swayimg recursive (mtime)";
        }
        {
          on = [
            "i"
            "G"
          ];
          run = "shell 'swayimg -r -o mtime --gallery \"$@\"' --orphan";
          desc = "Swayimg gallery (mtime)";
        }
        {
          on = [
            "i"
            "r"
          ];
          run = "shell 'swayimg -r -o random \"$@\"' --orphan";
          desc = "Swayimg recursive (random)";
        }
        {
          on = [
            "i"
            "R"
          ];
          run = "shell 'swayimg -r -o random --gallery \"$@\"' --orphan";
          desc = "Swayimg gallery (random)";
        }
      ];
    };
  };
}
