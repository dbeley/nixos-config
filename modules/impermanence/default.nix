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
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/fprint"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"
      "/etc/NetworkManager/system-connections"
      "/etc/wireguard"
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
      "Musique"
      "Nextcloud"
      "Téléchargements"
      "Games"
      "nfs"
      ".gnupg"
      ".ssh"
      ".config/chromium"
      ".config/gtk-3.0"
      ".config/keepassxc"
      ".config/libreoffice/4/user"
      ".config/mpdscrobble"
      ".config/mpd"
      ".config/supersonic"
      ".config/beets"
      ".config/Nextcloud"
      ".local/share/direnv"
      ".local/share/flatpak"
      ".local/share/keyrings"
      ".local/share/mpd"
      ".mozilla/firefox/david"
      ".mozilla/native-messaging-hosts"
      ".cache/tealdeer/tldr-pages"
      ".var/app"
      ".config/heroic/GamesConfig"
      ".config/heroic/store"
      ".config/heroic/tools"
      ".config/heroic/gog_store"
      ".config/heroic/legendaryConfig"
      ".config/heroic/nile_config"
      ".local/share/Steam"
      ".local/share/Baba_Is_You"
      ".local/share/Celeste"
      ".local/share/HotlineMiami"
      ".local/Tendershoot"
      ".cache/keepassxc"
      ".cache/supersonic"
      ".local/share/zoxide"
      ".local/share/fish"
      ".cache/fish/generated_completions"
      ".wine"
      ".config/itch"
      ".renpy"
      ".config/Meltytech"
      ".config/audacity"
      ".zen"
      ".config/discord"
      ".config/nuclearthrone"
      ".local/share/CassetteBeasts"
      ".local/share/Monster Sanctuary"
      ".config/unity3d"
      ".cache/thumbnails/x-large"
    ];
    files = [
      ".cache/tofi-compgen"
      ".local/state/tofi-history"
      ".steam/registry.vdf"
      ".config/monitors.xml"
    ];
  };

  fileSystems."/persistent".neededForBoot = true;
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

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
