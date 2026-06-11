{
  pkgs,
  lib,
  ...
}:
{
  services.xserver = {
    # what's that doing in localization?
    # enable = lib.mkDefault true;
    # i get it that it's for xkb but we should setup xkb "optionally"
    # if user is willing to use xkb, not force to use xkb

    # Uzbek keyboard
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
