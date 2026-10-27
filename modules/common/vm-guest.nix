{ lib, ... }:
{
  hardware.enableRedistributableFirmware = lib.mkDefault false;
}
