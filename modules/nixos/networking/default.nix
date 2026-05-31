{
  lib,
  pkgs,
  ...
}:
{
  config = {
    networking = {
      networkmanager.enable = lib.mkDefault true;
      wireless.enable = lib.mkDefault false;
      nameservers = lib.mkDefault [
        # quad9
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
        # AdGuard DNS
        "94.140.14.14"
        "94.140.15.15"
        "2a10:50c0::ad1:ff"
        "2a10:50c0::ad2:ff"
      ];
    };
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
