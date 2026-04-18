{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    android-tools
    ccache
  ];

  nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" ];

  systemd.tmpfiles.rules = [
    "d /var/cache/ccache 0775 root nixbld -"
  ];
}
