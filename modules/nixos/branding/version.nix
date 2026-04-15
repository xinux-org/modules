{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.system.nixos;
  mcfg = config.xinux.osInfo;
  needsEscaping = s: null != builtins.match "[a-zA-Z0-9]+" s;
  escapeIfNeccessary =
    s: if needsEscaping s then s else ''"${lib.escape [ "\$" "\"" "\\" "\`" ] s}"'';
  attrsToText =
    attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: "${n}=${escapeIfNeccessary (toString v)}") attrs
    )
    + "\n";
  osReleaseContents = {
    NAME = "Xinux";
    ID = "xinux";
    VERSION = "${cfg.release} (${mcfg.codeName})";
    VERSION_CODENAME = lib.toLower mcfg.codeName;
    VERSION_ID = cfg.release;
    BUILD_ID = cfg.version;
    PRETTY_NAME = "Xinux ${cfg.release} (${mcfg.codeName})";
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
    enable = lib.mkEnableOption "Xinux Main System";
    codeName = lib.mkOption {
      type = lib.types.str;
      default = "Mahalla";
      description = "Codename for the current release";
    };
  };

  config = lib.mkIf config.xinux.osInfo.enable {
    environment.etc."os-release".text = lib.mkForce (attrsToText osReleaseContents);
    environment.etc."lsb-release".text = lib.mkForce (attrsToText {
      LSB_VERSION = "${cfg.release} (${mcfg.codeName})";
      DISTRIB_ID = "xinux";
      DISTRIB_RELEASE = cfg.release;
      DISTRIB_CODENAME = lib.toLower mcfg.codeName;
      DISTRIB_DESCRIPTION = "Xinux ${cfg.release} (${mcfg.codeName})";
    });
    boot.initrd.systemd.contents."/etc/os-release".source = lib.mkForce initrdRelease;
    boot.initrd.systemd.contents."/etc/initrd-release".source = lib.mkForce initrdRelease;
    boot.plymouth.enable = lib.mkDefault true;
    system.nixos.distroName = "Xinux";
    system.nixos.distroId = "xinux";
  };
}
