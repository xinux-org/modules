{ inputs, pkgs, ... }:
{
  services.xserver = {
    enable = true;

    # add uzbek keyboard
    xkb = {
      # Switch between layouts using Alt+Shift
      options = "grp:alt_shift_toggle,lv3:ralt_switch";

      extraLayouts = {
        uz = {
          description = "Uzbek";
          languages = [ "uzb" ];
          symbolsFile = "${inputs.uz-xkb}/uz_compat";
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
