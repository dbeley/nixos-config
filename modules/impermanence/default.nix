{
  hostName,
  lib,
  pkgs,
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
      {
        inherit user;
        directory = "/tmp/yazi-1000";
        group = "users";
        mode = "u=rwx,g=rx,o=";
      }
      "/var/log"
      "/etc/NetworkManager/system-connections"
      "/etc/wireguard"
      "/var/cache/ccache"
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
      "/var/lib/private"
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
      ".cache/nix"
      ".cache/noctalia"
      ".cache/opencode"
      ".cache/supersonic"
      ".cache/tealdeer"
      ".cache/thumbnails/x-large"
      ".agent/skills"
      ".claude"
      ".codex"
      ".hermes"
      ".omp"
      ".pi"
      ".zeroclaw"
      ".config/.copilot"
      ".config/audacity"
      ".config/backrest"
      ".config/beets"
      ".config/chromium"
      ".config/Cursor"
      ".config/dconf"
      ".config/discord"
      ".config/feishin"
      ".config/gh"
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
      ".config/mozilla/firefox/${user}"
      ".config/mpd"
      ".config/Nextcloud"
      ".config/nix"
      ".config/nuclearthrone"
      ".config/opencode"
      ".config/openmw"
      ".config/restic"
      ".config/rclone"
      ".config/supersonic"
      ".config/unity3d"
      ".config/Mullvad VPN"
      ".config/sops"
      ".config/zen/${user}"
      ".cursor"
      ".gemini"
      ".gnupg"
      ".local/share/Baba_Is_You"
      ".local/share/backrest"
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
      ".local/share/opencode"
      ".local/share/openmw"
      ".local/share/qutebrowser/sessions"
      ".local/share/Steam"
      ".local/share/zoxide"
      ".local/state/noctalia"
      ".local/state/opencode"
      ".local/Tendershoot"
      ".mozilla/native-messaging-hosts"
      ".mwarband"
      ".ollama"
      ".renpy"
      ".ssh"
      ".steam"
      ".var/app"
      ".wine"
      # Personal projects
      ".config/impulse"
      ".local/share/impulse"
      ".config/mpdscrobble"
      ".local/share/symmetri"
    ];
    files = [
      ".claude.json"
      ".local/state/tofi-history"
    ];
  };

  fileSystems = {
    "/persistent".neededForBoot = true;
    "/nix".neededForBoot = true;
  };

  boot.initrd.systemd = {
    services.impermanence-btrfs-rolling-root = {
      description = "Archiving existing BTRFS root subvolume and creating a fresh one";
      # Specify dependencies explicitly
      unitConfig.DefaultDependencies = false;
      # The script needs to run to completion before this service is done
      serviceConfig = {
        Type = "oneshot";
        # NOTE: to be able to see errors in your script do this
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
      # This service is required for boot to succeed
      requiredBy = [ "initrd.target" ];
      # Should complete before any file systems are mounted
      before = [ "sysroot.mount" ];

      # Wait until the root device is available
      # If you're altering a different device, specify its device unit explicitly.
      # see: systemd-escape(1)
      requires = [ "initrd-root-device.target" ];
      after = [
        "initrd-root-device.target"
        # Allow hibernation to resume before trying to alter any data
        "local-fs-pre.target"
      ];

      # The body of the script. Make your changes to data here
      script = ''
        mkdir /btrfs_tmp
        mount /dev/mapper/root_vg_${hostName} /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/persistent/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/persistent/old_roots/$timestamp"
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
    };
    extraBin = {
      "mkdir" = "${pkgs.coreutils}/bin/mkdir";
      "date" = "${pkgs.coreutils}/bin/date";
      "stat" = "${pkgs.coreutils}/bin/stat";
      "mv" = "${pkgs.coreutils}/bin/mv";
      "find" = "${pkgs.findutils}/bin/find";
      "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
    }; # NOTE: path = [...]; doesnt work for initrd, use full paths in your script or extraBin
  };

  # Temporary workaround for Téléchargements folder, see https://github.com/nix-community/impermanence/issues/290
  systemd.mounts = [
    {
      name = lib.mkForce "home-${user}-T\\xc3\\xa9l\\xc3\\xa9chargements.mount"; # result of `systemd-escape home/${user}/Téléchargements.mount`
      wantedBy = [ "local-fs.target" ];
      before = [ "local-fs.target" ];
      where = "/home/${user}/Téléchargements";
      what = "/persistent/home/${user}/Téléchargements";
      unitConfig.DefaultDependencies = false;
      type = "none";
      options = lib.concatStringsSep "," [
        "bind"
        "x-gvfs-hide"
      ];
    }
  ];

}
