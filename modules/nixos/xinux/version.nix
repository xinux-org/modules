{ lib, config, options, pkgs, ... }:

with lib;
let
  cfg = config.system.nixos;
  needsEscaping = s: null != builtins.match "[a-zA-Z0-9]+" s;
  escapeIfNeccessary = s: if needsEscaping s then s else ''"${escape [ "\$" "\"" "\\" "\`" ] s}"'';
  attrsToText = attrs:
    concatStringsSep "\n"
      (
        mapAttrsToList (n: v: ''${n}=${escapeIfNeccessary (toString v)}'') attrs
      ) + "\n";
  osReleaseContents = {
    NAME = "Xinux";
    ID = "xinux";
    VERSION = "${cfg.release} (${cfg.codeName})";
    VERSION_CODENAME = toLower cfg.codeName;
    VERSION_ID = cfg.release;
    BUILD_ID = cfg.version;
    PRETTY_NAME = "Xinux ${cfg.release} (${cfg.codeName})";
    LOGO = "nix-xinux-white";
    HOME_URL = "https://xinux.uz";
    DOCUMENTATION_URL = "";
    SUPPORT_URL = "";
    BUG_REPORT_URL = "";
  };
  initrdReleaseContents = osReleaseContents // {
    PRETTY_NAME = "${osReleaseContents.PRETTY_NAME} (Initrd)";
  };
  initrdRelease = pkgs.writeText "initrd-release" (attrsToText initrdReleaseContents);
in
{
  options.xinux.osInfo = {
    enable = mkEnableOption "Xinux Main System";
  };

  config = mkIf config.xinux.osInfo.enable {
    environment.etc."os-release".text = mkForce (attrsToText osReleaseContents);
    environment.etc."lsb-release".text = mkForce (attrsToText {
      LSB_VERSION = "${cfg.release} (${cfg.codeName})";
      DISTRIB_ID = "xinux";
      DISTRIB_RELEASE = cfg.release;
      DISTRIB_CODENAME = toLower cfg.codeName;
      DISTRIB_DESCRIPTION = "Xinux ${cfg.release} (${cfg.codeName})";
    });
    boot.initrd.systemd.contents."/etc/os-release".source = mkForce initrdRelease;
    boot.initrd.systemd.contents."/etc/initrd-release".source = mkForce initrdRelease;
    boot.plymouth.enable = mkDefault true;
    system.nixos.distroName = "Xinux";
    system.nixos.distroId = "xinux";
  };
}
