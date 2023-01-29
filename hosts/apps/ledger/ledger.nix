{
  programs.ledger = {
    enable = true;
    extraConfig = ''
      --date-format %d/%m/%Y
      --input-date-format %d/%m/%Y
      --file ~/Nextcloud/02_Suivi/ledger.ledger
      --sort date
    '';
  };
}
