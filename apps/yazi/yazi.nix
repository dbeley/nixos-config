{ config, pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableFishIntegration = true;

    plugins = {
      inherit (pkgs.yaziPlugins) smart-enter;
      mime-ext = pkgs.yaziPlugins.mime-ext;
    };

    initLua = ''
      require("smart-enter"):setup({})
      require("mime-ext.local"):setup({
        fallback_file1 = false,
      })
    '';

    settings = {
      preview = {
        cache_dir = "${config.home.homeDirectory}/.cache/yazi";
      };
      mgr = {
        linemode = "size";
      };
      plugin = {
        prepend_preloaders = [
          {
            url = "${config.home.homeDirectory}/nfs/**";
            run = "noop";
          }
        ];
        prepend_fetchers = [
          {
            url = "local://${config.home.homeDirectory}/nfs/**";
            run = "mime-ext.local";
            prio = "high";
            group = "mime";
          }
        ];
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        # Smart enter: Enter directory or open file
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Smart enter";
        }
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
            "x"
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
            "m"
          ];
          run = "cd ~/nfs/WDC14/Musique";
          desc = "Bookmark: Medias";
        }
        {
          on = [
            "b"
            "n"
          ];
          run = "cd ~/nfs/WDC14_2/Nixflix";
          desc = "Bookmark: Nixflix";
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
          run = "shell --orphan 'swayimg -e \"swayimg.imagelist.order = \\\"mtime\\\"\" -- %h'";
          desc = "Swayimg recursive (mtime)";
        }
        {
          on = [
            "i"
            "G"
          ];
          run = "shell --orphan 'swayimg -g -e \"swayimg.imagelist.order = \\\"mtime\\\"\" -- %h'";
          desc = "Swayimg gallery (mtime)";
        }
        {
          on = [
            "i"
            "r"
          ];
          run = "shell --orphan 'swayimg -e \"swayimg.imagelist.order = \\\"random\\\"\" -- %h'";
          desc = "Swayimg recursive (random)";
        }
        {
          on = [
            "i"
            "R"
          ];
          run = "shell --orphan 'swayimg -g -e \"swayimg.imagelist.order = \\\"random\\\"\" -- %h'";
          desc = "Swayimg gallery (random)";
        }
      ];
    };
  };
}
