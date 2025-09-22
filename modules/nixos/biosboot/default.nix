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
        devices = ["nodev"];
        useOSProber = true;
        theme = pkgs.stdenv.mkDerivation {
          pname = "bootloader-theme";
          version = "1.0.2";
          src = pkgs.fetchFromGitHub {
            owner = "xinux-org";
            repo = "bootloader-theme";
            tag = "v1.0.2";
            hash = "sha256-uEZfnhmXpjgmikppTlM8OQ5FAsmFdvi8dwIAZtaQ/MQ=";
          };
          installPhase = "cp -r $src/nixos $out";
        };
      };
    };
    boot.tmp.cleanOnBoot = mkDefault true;
  };
}
