{
  inputs,
  pkgs,
  domain,
  ...
}:
{
  # stave exposes its module double-curried ({ pkgs, ... }: { config, ... }: …),
  # which this nixpkgs cannot resolve from an `imports` entry. Pre-apply the
  # outer function so the module system receives the inner module directly.
  imports = [ (inputs.stave.nixosModules.default { inherit pkgs; }) ];

  services.stave = {
    enable = true;
    hostName = "stave.${domain}";
  };

  services.nginx.virtualHosts."stave.${domain}" = {
    useACMEHost = domain;
    forceSSL = true;
  };
}
