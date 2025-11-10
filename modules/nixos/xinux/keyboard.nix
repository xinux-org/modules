{pkgs, ...}: {
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      extraLayouts.uz = {
        description = "Uzbek (Oʻzbekiston)";
        languages = ["eng" "uzb"];
        symbolsFile = ../../../.github/assets/uz;
      };
      layout = "uz,us";
      variant = "latin";
    };
  };
  environment.systemPackages = with pkgs; [
    hunspellDicts.uz_UZ
  ];
}