{
  lib,
  config,
  ...
}:
with lib;
{
  imports = [
    ./version.nix
  ];

  config = {
    xinux.osInfo.enable = mkDefault true;
  };
}
