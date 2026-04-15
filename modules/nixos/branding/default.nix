{
  lib,
  ...
}:
{
  imports = [
    ./version.nix
  ];

  xinux.osInfo.enable = lib.mkDefault true;
}
