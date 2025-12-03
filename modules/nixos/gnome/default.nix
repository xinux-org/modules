{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.gnome;
in {
  options.modules.gnome = with types; {
    gsconnect.enable =
      mkEnableOption "Enable KDE Connect integration";
    removeUtils.enable = mkOption {
      type = bool;
      default = false;
      description = "Remove non-essential GNOME utilities";
    };
  };

  config = mkMerge [
    {
      # Enable the GNOME Desktop Environment.
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.xserver.enable = true;
      services.displayManager.gdm.wayland = true;

      # Fix GNOME autologin
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      programs.kdeconnect = mkIf cfg.gsconnect.enable {
        package = pkgs.gnomeExtensions.gsconnect;
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        gnome-console
        inputs.xinux-tour.packages.${pkgs.stenv.hostPlatform.system}.default
      ];
    }
    (mkIf cfg.removeUtils.enable {
      modules.xinux.nixosConfEditor.enable = lib.mkDefault false;
      modules.xinux.eimzoIntegraion.enable = lib.mkDefault false;

      services.gnome.core-utilities.enable = false;

      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
      ];
    })
  ];
}
