{pkgs, ...}: {
  services.xserver = {
    enable = true;

    # add uzbek keyboard
    xkb = {
      extraLayouts.uz = {
        description = "Uzbek (Oʻzbekiston)";
        languages = ["eng" "uzb"];
        symbolsFile = ../../../.github/assets/uz;
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
