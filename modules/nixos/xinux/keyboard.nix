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
  environment.systemPackages = with pkgs; [
    hunspellDicts.uz_UZ
  ];
}
