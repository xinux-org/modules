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
    boot.loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        useOSProber = true;
        theme = pkgs.stdenv.mkDerivation {
          pname = "bootloader-theme";
          version = "1.0.3";
          src = pkgs.fetchFromGitHub {
            owner = "xinux-org";
            repo = "bootloader-theme";
            tag = "v1.0.3";
            hash = "sha256-ipaiJiQ3r2B3si1pFKdp/qykcpaGV+EqXRwl6UkCohs=";
          };
          installPhase = "cp -r $src/nixos $out";
        };
      };
    };
    boot.tmp.cleanOnBoot = mkDefault true;
  };
}
