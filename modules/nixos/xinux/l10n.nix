{ inputs, pkgs, ... }:
{
  services.xserver = {
    enable = true;

    # add uzbek keyboard
    xkb = {
      # Switch between layouts using Alt+Shift
      options = "grp:alt_shift_toggle,lv3:ralt_switch";

      extraLayouts = {
        uzx = {
          description = "Uzbek (Custom, Latin)";
          languages = [ "uzb" ];
          symbolsFile = "${inputs.uz-xkb}/uz_latin";
        };
        uzx-us = {
          description = "Uzbek (Custom, US)";
          languages = [ "uzb" ];
          symbolsFile = "${inputs.uz-xkb}/uz_us";
        };
        uzx-2023 = {
          description = "Uzbek (Custom, 2023)";
          languages = [ "uzb" ];
          symbolsFile = "${inputs.uz-xkb}/uz_2023";
        };
        uzx-cyrillic = {
          description = "Uzbek (Custom, Cyrillic)";
          languages = [ "uzb" ];
          symbolsFile = "${inputs.uz-xkb}/uz_cyrillic";
        };
      };
    };
  };
  environment.systemPackages = [
    pkgs.hunspellDicts.uz_UZ
  ];

  i18n = {
    extraLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
      "uz_UZ.UTF-8/UTF-8"
    ];
  };
}
