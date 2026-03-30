{
  pkgs,
  lib,
  ...
}:
with lib;
{
  services.xserver = {
    enable = mkDefault true;

    # add uzbek keyboard
    xkb = {
      # Switch between layouts using Alt+Shift
      options = mkDefault "grp:alt_shift_toggle,lv3:ralt_switch";

      extraLayouts = mkDefault {
        uz = {
          description = "Uzbek";
          languages = [ "uzb" ];
          symbolsFile = ./uz_compat;
        };
      };
    };
  };
  environment.systemPackages = mkDefault [
    pkgs.hunspellDicts.uz_UZ
  ];

  i18n = {
    extraLocales = mkDefault [
      "all"
    ];
    supportedLocales = mkDefault [
      "all"
    ];
  };
}
