{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.efiboot;
  efiSysMountPoint = config.boot.loader.efi.efiSysMountPoint;
in {
  options.modules.efiboot = with types; {
    bootloader = mkOption {
      type = enum ["grub" "systemd-boot"];
      default = "grub";
      description = "The kernel to use for booting.";
    };
  };

  config = mkMerge [
    (mkIf (cfg.bootloader == "systemd-boot")
      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.systemd-boot.editor = mkDefault false;
      })
    (mkIf (cfg.bootloader == "grub") {
      # boot.loader.systemd-boot.enable = false;
      # boot.loader.efi.canTouchEfiVariables = true;
      # boot.loader.grub.enable = true;
      # boot.loader.grub.devices = ["nodev"];
      # boot.loader.grub.efiSupport = true;
      # boot.loader.grub.useOSProber = true;
      boot.loader = {
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          #splashImage = ./background.png;
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
    })
    {
      boot.tmp.cleanOnBoot = mkDefault true;
      # Temporary workaround for "random seed file is world accessible"
      fileSystems.${efiSysMountPoint}.options =
        mkIf (config.fileSystems.${efiSysMountPoint}.fsType == "vfat") ["umask=0077"];
    }
  ];
}
