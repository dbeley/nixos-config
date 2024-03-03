{ user, ... }: {
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  # users.users.${user}.extraGroups = [ "docker" ];
}
