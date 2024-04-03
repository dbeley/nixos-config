{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hledger
    hledger-ui
    hledger-web
  ];
  programs.ledger = {
    enable = true;
    extraConfig = ''
      --date-format %d/%m/%Y
      --input-date-format %d/%m/%Y
      --file ledger.ledger
      --sort date
    '';
  };
}
