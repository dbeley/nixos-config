{ pkgs, ... }:

let
  zoomPlugin =
    pkgs.runCommand "zoom.yazi"
      {
        src = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "598cdb671401574ac27aeee257e2f3b0c80610a1";
          hash = "sha256-bqGN6JxbU+/o7TlM/Cm9Qj/s1McA4pB5QWArGZPcme4=";
        };
      }
      ''
        cp -r $src/zoom.yazi/. $out
      '';

in
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableFishIntegration = true;

    plugins = {
      inherit (pkgs.yaziPlugins) smart-enter;
      zoom = zoomPlugin;
    };

    initLua = ''
      require("smart-enter"):setup({})
    '';

    settings = {
      mgr = {
        linemode = "size";
      };
      plugin = {
        prepend_previewers = [
          {
            mime = "image/{jpeg,png,webp,bmp}";
            run = "zoom 5";
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
        # Zoom in/out
        {
          on = "+";
          run = "plugin zoom 1";
          desc = "Zoom in";
        }
        {
          on = "-";
          run = "plugin zoom -1";
          desc = "Zoom out";
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
            "i"
          ];
          run = "cd ~/nfs/WDC14_2/Medias";
          desc = "Bookmark: Medias";
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
