{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.gnome;
in
{
  options.modules.gnome = {
    gsconnect.enable = lib.mkEnableOption "Enable KDE Connect integration";
    remove-utils.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Remove non-essential GNOME utilities";
    };
    new-settings.enable = lib.mkEnableOption "the new Settings application replacement.";
  };
  config = lib.mkMerge [
    {
      # Enable the GNOME Desktop Environment.
      services = {
        displayManager = {
          gdm = {
            enable = true;
          };
        };
        desktopManager.gnome.enable = true;
        xserver.enable = true;
      };

      # Fix GNOME autologin
      systemd = {
        services = {
          "getty@tty1" = {
            enable = false;
          };
          "autovt@tty1" = {
            enable = false;
          };
        };
      };

      programs.kdeconnect = lib.mkIf cfg.gsconnect.enable {
        package = pkgs.gnomeExtensions.gsconnect;
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        gnome-console
        gnome-extension-manager
        pkgs.xinux-tour
      ];
    }
    (lib.mkIf cfg.removeUtils.enable {
      modules.xinux.eimzoIntegraion.enable = lib.mkDefault false;

      services.gnome.core-utilities.enable = false;

      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
      ];
    })
    (lib.mkIf cfg.new-settings.enable {
      environment.systemPackages = [
        pkgs.xinux-settings
      ];
    })
  ];
}
