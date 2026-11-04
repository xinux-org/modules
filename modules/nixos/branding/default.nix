{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./version.nix
  ];

  xinux.osInfo.enable = lib.mkDefault true;

  environment.systemPackages = [
    pkgs.internal.xinux-icon
  ];
}
