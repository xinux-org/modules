{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.biosboot;
in {
  config = {
    boot = {
      loader = {
        systemd-boot.enable = false;
        grub = {
          enable = true;
          #splashImage = ./background.png;
          useOSProber = true;
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
        themePackages = [pkgs.mac-style-plymouth];
      };
    };
    boot.tmp.cleanOnBoot = mkDefault true;
  };
}
