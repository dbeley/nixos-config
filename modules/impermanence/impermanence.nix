{ user, ... }:
{
  home.persistence."/persistent/home/${user}" = {
    directories = [
      "Documents"
      "Musique"
      "Nextcloud"
      "Téléchargements"
      {
        directory = "nfs";
        method = "symlink";
      }
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".steam"
      ".mozilla/firefox/david"
      # ".cache/mozilla/firefox/david"
      ".local/share/mpd"
    ];
    files = [
      ".config/Nextcloud/cookies0.db"
      ".config/keepassxc/keepassxc.ini"
      ".local/share/zoxide/db.zo"
    ];
    allowOther = true;
  };
}
