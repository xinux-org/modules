{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}
