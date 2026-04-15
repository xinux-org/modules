{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.efiboot;
  efiSysMountPoint = config.boot.loader.efi.efiSysMountPoint;
in
{
  options.modules.efiboot = with lib.types; {
    bootloader = lib.mkOption {
      type = enum [
        "grub"
        "systemd-boot"
      ];
      default = "grub";
      description = "The kernel to use for booting.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.bootloader == "systemd-boot") {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.systemd-boot.editor = lib.mkDefault false;
    })
    (lib.mkIf (cfg.bootloader == "grub") {
      boot = lib.mkDefault {
        loader = {
          systemd-boot.enable = false;
          efi.canTouchEfiVariables = true;
          grub = {
            enable = true;
            devices = [ "nodev" ];
            useOSProber = true;
            efiSupport = true;
            theme = "${
              (pkgs.fetchFromGitHub {
                owner = "xinux-org";
                repo = "bootloader-theme";
                tag = "v1.0.3";
                hash = "sha256-ipaiJiQ3r2B3si1pFKdp/qykcpaGV+EqXRwl6UkCohs=";
              })
            }/xinux";
          };
        };
        plymouth = {
          enable = true;
          theme = "mac-style";
          themePackages = [
            inputs.mac-style-plymouth.packages."${pkgs.stdenv.hostPlatform.system}".default
          ];
        };
      };
    })
    {
      boot.tmp.cleanOnBoot = lib.mkDefault true;
      # Temporary workaround for "random seed file is world accessible"
      fileSystems.${efiSysMountPoint}.options = lib.mkIf (
        config.fileSystems.${efiSysMountPoint}.fsType == "vfat"
      ) [ "umask=0077" ];
    }
  ];
}
