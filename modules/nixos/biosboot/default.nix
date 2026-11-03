{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.biosboot;
  xinux-grub-theme = inputs.xinux-grub-theme.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
{
  config = {
    boot = {
      loader = {
        systemd-boot.enable = false;
        grub = {
          enable = true;
          devices = [ "nodev" ];
          useOSProber = true;
          efiSupport = true;
          theme = "${xinux-grub-theme}/grub/themes/xinux";
        };
      };
    };
    boot.tmp.cleanOnBoot = lib.mkDefault true;

    # Silence boot messages
    boot.consoleLogLevel = lib.mkDefault 0;
    boot.kernelParams = [
      "quiet"
      "udev.log_level=0"
    ];
  };
}
