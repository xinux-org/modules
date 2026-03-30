{
  lib,
  ...
}:
with lib;
{
  imports = [
    ./version.nix
  ];

  xinux.osInfo.enable = mkDefault true;
}
