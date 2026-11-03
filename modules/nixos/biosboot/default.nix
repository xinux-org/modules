{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
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
          #splashImage = ./background.png;
          useOSProber = true;
          efiSupport = true;
          theme = "${xinux-grub-theme}/grub/themes/xinux";
        };
      };
    };
    boot.tmp.cleanOnBoot = mkDefault true;
  };
}
