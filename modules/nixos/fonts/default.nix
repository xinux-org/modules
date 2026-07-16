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
    base-fonts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Foundation fonts for everything.";
    };

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
    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = builtins.concatLists [
        (lib.optionals cfg.base-fonts (
          with pkgs;
          [
            # TODO: clean up fonts that aren't necessary
            ubuntu-classic
            font-bh-ttf
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            nerd-fonts.jetbrains-mono
            mplus-outline-fonts.osdnRelease
            fira-code
            fira-code-symbols
            hermit
            source-code-pro
            terminus_font
            font-awesome
            font-awesome_4
            hack-font
            noto-fonts
            # An alternative popular Chinese font
            wqy_zenhei
            # cantarell-fonts
            powerline-fonts
            roboto
            roboto-slab
            montserrat
            inter
            lato
            eb-garamond
            fira-code
            fira-code-symbols
            mplus-outline-fonts.githubRelease
            dina-font
            proggyfonts
            oswald
            rubik
            freefont_ttf
            mononoki
            iosevka
          ]
        ))

        (lib.optionals cfg.windows-fonts (
          with pkgs;
          [
            corefonts
            carlito
            vista-fonts
            vista-fonts-chs
          ]
        ))

        # Whatever to come out from apple-fonts flake
        # HINT: evaluate apple-fonts.packages for more.
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

        # Install whole nerd-fonts collection
        (lib.optionals cfg.nerd-fonts (
          builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
        ))

        # Fonts chosen by designers
        (lib.optionals cfg.designer-picked (with pkgs; [ ]))
      ];
    };
  };
}
