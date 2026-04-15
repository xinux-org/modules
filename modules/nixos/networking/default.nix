{
  lib,
  pkgs,
  ...
}:
{
  config = {
    networking.networkmanager.enable = lib.mkDefault true;
    networking.wireless.enable = lib.mkDefault false;
    # Workaround for https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.networkmanager}/bin/nm-online -q"
        ];
      };
    };
  };
}
