{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rclone
    restic
  ];

  programs.fish = {
    shellAliases = {
      backup-init = "restic -r rclone:onedrive:backup init";
      backup-status = "restic -r rclone:onedrive:backup snapshots";
      backup-restore = "restic -r rclone:onedrive:backup restore latest --target ~/restic-restore";
      backup-forget = "restic -r rclone:onedrive:backup forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 3 --prune";
      backup-check = "restic -r rclone:onedrive:backup check";
      rclone-config = "rclone config";
    };

    functions = {
      backup-run = ''
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
          restic -r rclone:onedrive:backup --verbose backup $expanded_folder
        end
      '';
    };
  };
}
