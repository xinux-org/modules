{
  pkgs,
  lib,
  ...
}:
{
  services.xserver = {
    enable = lib.mkDefault true;

    # add uzbek keyboard
    xkb = {
      # Switch between layouts using Alt+Shift
      options = lib.mkDefault "grp:alt_shift_toggle,lv3:ralt_switch";

      extraLayouts.uz = lib.mkDefault {
        description = "Uzbek";
        languages = [ "uzb" ];
        symbolsFile = ./uz_compat;
      };
    };
  };
  environment.systemPackages = [
    pkgs.hunspellDicts.uz_UZ
  ];

  i18n = {
    extraLocales = lib.mkDefault [
      "all"
    ];
    supportedLocales = lib.mkDefault [
      "all"
    ];
  };
}
