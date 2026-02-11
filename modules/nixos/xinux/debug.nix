{
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib; {
  options.xinux.debug = {
    enable = mkEnableOption "Enable debug mode for internal remote development.";
  };

  config = mkIf config.xinux.debug.enable {
    users.users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHckzEwlJW/H8Y6dHVut/sMiTXtXNq1KrT1l9b5UTQU Xinux Only For Development Purposes"
      ];
    };

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };
  };
}
