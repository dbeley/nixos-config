{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    rclone
    restic
  ];

  programs.fish = {
    functions = {
      backup-repo = ''
        if set -q argv[1]
          echo $argv[1]
        else
          echo rclone:onedrive:backup
        end
      '';
      backup-init = ''
        restic -r (backup-repo $argv) --password-file ~/.config/restic/password init
      '';
      backup-status = ''
        restic -r (backup-repo $argv) --password-file ~/.config/restic/password snapshots
      '';
      backup-restore = ''
        restic -r (backup-repo $argv) --password-file ~/.config/restic/password restore latest --target ~/restic-restore
      '';
      backup-forget = ''
        restic -r (backup-repo $argv) --password-file ~/.config/restic/password forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 3 --prune
      '';
      backup-check = ''
        restic -r (backup-repo $argv) --password-file ~/.config/restic/password check
      '';
      backup-unlock = ''
        restic -r (backup-repo $argv) --password-file ~/.config/restic/password unlock
      '';
      backup-run = ''
        set repo (backup-repo $argv)
        set folders_file ~/.config/restic/backup-folders.txt

        if not test -f $folders_file
          echo "No backup folders configured."
          echo "Create $folders_file with one folder path per line."
          echo ""
          echo "Example:"
          echo "  mkdir -p ~/.config/restic"
          echo "  echo '~/Nextcloud' >> ~/.config/restic/backup-folders.txt"
          return 1
        end

        for folder in (cat $folders_file | grep -v '^#' | grep -v '^$')
          set expanded_folder (eval echo $folder)
          echo "Backing up: $expanded_folder"
          restic -r $repo --verbose --password-file ~/.config/restic/password backup $expanded_folder
        end
      '';
    };
  };
  sops.secrets = {
    restic-password = {
      key = "restic_password";
      path = "${config.home.homeDirectory}/.config/restic/password";
    };
  };
}
