{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    windows-fonts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Windows font support.";
    };

    nerd-fonts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install nerd-fonts collection.";
    };

    apple-fonts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Apple provided/produced fonts.";
    };

    designer-picked = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Handpicked collection of fonts by designers.";
    };
  };

  config = {
    fonts.packages = builtins.concatLists [
      (lib.optionals cfg.windows-fonts (
        with pkgs;
        [
          corefonts
          carlito
          vista-fonts
          vista-fonts-chs
        ]
      ))

      (lib.optionals cfg.apple-fonts (
        with inputs.apple-fonts.packages;
        [
          ny
          ny-nerd
          sf-arabic
          sf-arabic-nerd
          sf-armenian
          sf-armenian-nerd
          sf-compact
          sf-compact-nerd
          sf-georgian
          sf-georgian-nerd
          sf-hebrew
          sf-hebrew-nerd
          sf-mono
          sf-mono-nerd
          sf-pro
          sf-pro-nerd
        ]
      ))

      (lib.optionals cfg.nerd-fonts (
        with pkgs;
        [
          corefonts
          carlito
          vista-fonts
          vista-fonts-chs
        ]
      ))

      (lib.optionals cfg.designer-picked (
        with pkgs;
        [
          corefonts
          carlito
          vista-fonts
          vista-fonts-chs
        ]
      ))
    ];
  };
}
