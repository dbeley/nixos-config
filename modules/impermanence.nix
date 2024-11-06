{ user, ... }:
{
  environment.persistence."/persistent" = {
    enable = true;  # NB: Defaults to true, not needed
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
    users.${user} = {
      directories = [
        "Documents"
        "Musique"
        "Nextcloud"
        "Téléchargements"
        "nfs"
        "nixos-config"
        "Downloads"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
        { directory = ".nixops"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
        ".local/share/direnv"
        ".mozilla"
        ".steam"
        ".config/beets"
        ".config/mpdscrobble"
        ".config/Nextcloud/cookies0.db"
      ];
      files = [
        ".screenrc"
      ];
    };
  };
}
