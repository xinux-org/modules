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
      boot.loader.systemd-boot.enable = lib.mkForce true;
      boot.loader.efi.canTouchEfiVariables = lib.mkForce true;
      boot.loader.systemd-boot.editor = lib.mkForce false;
    })
    (lib.mkIf (cfg.bootloader == "grub") {
      boot = {
        loader = {
          systemd-boot.enable = lib.mkForce false;
          efi.canTouchEfiVariables = lib.mkForce true;
          grub = {
            enable = lib.mkForce true;
            devices = lib.mkForce [ "nodev" ];
            useOSProber = lib.mkForce true;
            efiSupport = lib.mkForce true;
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
          enable = lib.mkForce true;
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
