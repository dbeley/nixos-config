{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.desk.nixosModules.desk ];

  programs.desk = {
    enable = true;

    extraPackages = with pkgs; [
      xfce4-terminal
      firefox
      thunar
      mousepad
    ];
  };
}
