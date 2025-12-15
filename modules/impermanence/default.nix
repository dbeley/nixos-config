{
  lib,
  hostName,
  user,
  ...
}:
{
  users.mutableUsers = lib.mkForce false;
  users.users.${user}.hashedPasswordFile = "/persistent/passwd_${user}";
  programs.fuse.userAllowOther = true;
  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/etc/NetworkManager/system-connections"
      "/etc/wireguard"
      "/var/lib/bluetooth"
      "/var/lib/boinc"
      "/var/lib/fprint"
      "/var/lib/iwd"
      "/var/lib/NetworkManager"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
    ];
  };
  # More stable than home-manager home.persistence."/persistent/home/${user}"
  environment.persistence."/persistent".users.${user} = {
    directories = [
      "Documents"
      "Games"
      "Musique"
      "Nextcloud"
      "nfs"
      "Téléchargements"
      ".cache/fish/generated_completions"
      ".cache/keepassxc"
      ".cache/supersonic"
      ".cache/tealdeer"
      ".cache/thumbnails/x-large"
      ".claude"
      ".codex"
      ".config/.copilot"
      ".config/audacity"
      ".config/beets"
      ".config/chromium"
      ".config/Cursor"
      ".config/discord"
      ".config/gtk-3.0"
      ".config/heroic/GamesConfig"
      ".config/heroic/gog_store"
      ".config/heroic/legendaryConfig"
      ".config/heroic/nile_config"
      ".config/heroic/store"
      ".config/heroic/tools"
      ".config/itch"
      ".config/keepassxc"
      ".config/libreoffice/4/user"
      ".config/Meltytech"
      ".config/mpd"
      ".config/Nextcloud"
      ".config/nix"
      ".config/nuclearthrone"
      ".config/supersonic"
      ".config/unity3d"
      ".cursor"
      ".gemini"
      ".gnupg"
      ".local/share/Baba_Is_You"
      ".local/share/Brotato"
      ".local/share/CassetteBeasts"
      ".local/share/Celeste"
      ".local/share/direnv"
      ".local/share/fish"
      ".local/share/flatpak"
      ".local/share/HotlineMiami"
      ".local/share/IntoTheBreach"
      ".local/share/keyrings"
      ".local/share/Monster Sanctuary"
      ".local/share/mpd"
      ".local/share/Steam"
      ".local/share/zoxide"
      ".local/Tendershoot"
      ".mozilla/firefox/david"
      ".mozilla/native-messaging-hosts"
      ".renpy"
      ".ssh"
      ".var/app"
      ".wine"
      ".zen"
      # personal projects
      ".config/impulse"
      ".config/mpdscrobble"
      ".local/share/symmetri"
    ];
    files = [
      ".claude.json"
    ];
  };

  fileSystems = {
    "/persistent".neededForBoot = true;
    "/nix".neededForBoot = true;
    "/var/log".neededForBoot = true;
  };

  # Impermanence
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/mapper/root_vg_${hostName} /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/persistent/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/persistent/old_roots/$timestamp/"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/persistent/old_roots/ -mindepth 1 -maxdepth 1 -mtime +1); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

}
