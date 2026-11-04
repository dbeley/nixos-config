{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    openttd
  ];
}
