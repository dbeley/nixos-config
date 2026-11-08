{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.sway ];
  services.displayManager.sessionPackages = [ pkgs.sway ];
  environment.sessionVariables = {
    GTK_IM_MODULE = "simple";
  };
}
