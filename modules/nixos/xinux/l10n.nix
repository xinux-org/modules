{pkgs, ...}: let
  xkbPath = "../../../.github/assest/xkb";
in {
  services.xserver = {
    enable = true;

    # add uzbek keyboard
    xkb = {
	  # Switch between layouts using Alt+Shift
      options = "grp:alt_shift_toggle";
      variant = "latin";
      layout = "uz,uz(latin),us,ru";

      extraLayouts = {
        uz = {
          description = "Uzbek";
          languages = ["uzb"];
          symbolsFile = "${xkbPath}/uz";
        };
        uz-us = {
          description = "Uzbek (US)";
          languages = ["uzb"];
          symbolsFile = "${xkbPath}/uz_us";
        };
        uz-2023 = {
          description = "Uzbek (2023)";
          languages = ["uzb"];
          symbolsFile = "${xkbPath}/uz_2023";
        };
        uz-cyrillic = {
          description = "Uzbek (Cyrillic)";
          languages = ["uzb"];
          symbolsFile = "${xkbPath}/uz_cyrillic";
        };
      };
    };

    # Switch between layouts using Alt+Shift
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
