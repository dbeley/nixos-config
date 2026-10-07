{ inputs, ... }:
{
  imports = [ inputs.autoscreen.homeModules.default ];

  services.autoscreen = {
    enable = true;
    destinationDir = "%h/Nextcloud/30-39_Images/32_Captures-d-écran/32.11_autoscreen";
    filenameSuffix = "nixos_";
    format = "jxl";
    quality = 90;
  };
}
