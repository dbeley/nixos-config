{ config, pkgs, ... }:

let
  r = pkgs.rclone;
in {
  home.packages = [ r ];

  # Your rclone config (password is "obscured" — see note below)
  home.file.".config/rclone/rclone.conf".text = ''
    [cloud]
    type = webdav
    url = URL/remote.php/dav/files/USER
    vendor = nextcloud
    user = USER
    pass = PASSWORD
  '';

  # Optional: filters to ignore junk files
  home.file.".config/rclone/nextcloud.filter".text = ''
    - .DS_Store
    - ._*
    - Thumbs.db
    - *.part
    - .sync/**
    + **
  '';

  # Ensure local target exists
  home.file."Nextcloud/.keep".text = "";

  # One‑shot bisync service (two‑way sync)
  systemd.user.services."rclone-bisync-cloud" = {
    Unit = {
      Description = "rclone bisync Nextcloud <-> ~/Nextcloud";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${r}/bin/rclone \
          bisync cloud: ${config.home.homeDirectory}/Nextcloud \
          --filters-file=${config.home.homeDirectory}/.config/rclone/nextcloud.filter \
          --check-access \
          --create-empty-src-dirs \
          --fast-list \
          --ignore-case-sync \
          --conflict-resolve newer \
          --track-renames \
          --max-delete 20 \
          --log-file=${config.home.homeDirectory}/.local/state/rclone/bisync.log \
          --log-level INFO
      '';
    };
    Install.WantedBy = [ "default.target" ];
  };

  # Run every 5 minutes (tweak if you like)
  systemd.user.timers."rclone-bisync-cloud" = {
    Unit.Description = "Timer: rclone bisync Nextcloud";
    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "5m";
      AccuracySec = "30s";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
