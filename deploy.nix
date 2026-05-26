{
  self,
  deploy-rs,
  nixpkgs,
  system ? "x86_64-linux",
}:
let
  pkgs = nixpkgs.legacyPackages.${system};
  deployLib = deploy-rs.lib.${system};

  sopsFile = ./secrets/secrets.yaml;

  decryptSops =
    key:
    let
      ageKeyFile = builtins.path {
        path = /home/david/.config/sops/age/keys.txt;
        name = "sops-age-key";
      };
      drv =
        pkgs.runCommand "sops-${key}"
          {
            nativeBuildInputs = [ pkgs.sops ];
            SOPS_AGE_KEY_FILE = ageKeyFile;
          }
          ''
            sops --decrypt --extract '["${key}"]' ${sopsFile} > $out
          '';
    in
    nixpkgs.lib.strings.trim (builtins.readFile drv);
in
{
  nodes = {
    "nixos-era-01" = {
      hostname = decryptSops "era_01_ip";
      sshUser = "david";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos self.nixosConfigurations.nixos-era-01;
      };
      magicRollback = true;
      autoRollback = true;
      interactiveSudo = true;
    };

    "nixos-era-02" = {
      hostname = decryptSops "era_02_ip";
      sshUser = "david";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos self.nixosConfigurations.nixos-era-02;
      };
      magicRollback = true;
      autoRollback = true;
      interactiveSudo = true;
    };

    "nixos-era-03" = {
      hostname = decryptSops "era_03_ip";
      sshUser = "david";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos self.nixosConfigurations.nixos-era-03;
      };
      magicRollback = true;
      autoRollback = true;
      interactiveSudo = true;
    };

    "nixos-era-04" = {
      hostname = decryptSops "era_04_ip";
      sshUser = "david";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos self.nixosConfigurations.nixos-era-04;
      };
      magicRollback = true;
      autoRollback = true;
      interactiveSudo = true;
    };

    "nixos-kimsufi-01" = {
      hostname = decryptSops "kimsufi_01_ip";
      sshUser = "david";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos self.nixosConfigurations.nixos-kimsufi-01;
      };
      magicRollback = true;
      autoRollback = true;
      interactiveSudo = true;
    };

    "nixos-kimsufi-02" = {
      hostname = decryptSops "kimsufi_02_ip";
      sshUser = "david";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos self.nixosConfigurations.nixos-kimsufi-02;
      };
      magicRollback = true;
      autoRollback = true;
      interactiveSudo = true;
    };

    "nixos-kimsufi-03" = {
      hostname = decryptSops "kimsufi_03_ip";
      sshUser = "david";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos self.nixosConfigurations.nixos-kimsufi-03;
      };
      magicRollback = true;
      autoRollback = true;
      interactiveSudo = true;
    };
  };
}
