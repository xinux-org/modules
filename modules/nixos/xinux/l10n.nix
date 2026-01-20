{pkgs, ...}: {
  services.xserver = {
    enable = true;

    # add uzbek keyboard
    xkb = {
      # Switch between layouts using Alt+Shift
      options = "grp:alt_shift_toggle,lv3:ralt_switch";
      variant = "latin";
      layout = "uz,uz-cyrillic,us,ru";

      extraLayouts = {
        uz = {
          description = "Uzbek";
          languages = ["uzb"];
          symbolsFile = ./xkb/uz;
        };
        uz-us = {
          description = "Uzbek (US)";
          languages = ["uzb"];
          symbolsFile = ./xkb/uz_us;
        };
        uz-2023 = {
          description = "Uzbek (2023)";
          languages = ["uzb"];
          symbolsFile = ./xkb/uz_2023;
        };
        uz-cyrillic = {
          description = "Uzbek (Cyrillic)";
          languages = ["uzb"];
          symbolsFile = ./xkb/uz_cyrillic;
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
