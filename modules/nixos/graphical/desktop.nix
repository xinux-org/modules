{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
  nixos-background-info = pkgs.stdenv.mkDerivation { name = "nixos-background-info"; };
in
{
  options.modules.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.graphical.enable;
      example = false;
      description = "Xinux GNOME configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.gnome = {
      extraGSettingsOverridePackages = [
        pkgs.gsettings-desktop-schemas
        pkgs.gnome-shell
      ];
    };

    # Setting daemons
    services = {
      # Udev daemon management
      udev.packages = with pkgs; [ gnome-settings-daemon ];
    };

    programs = {
      gnupg.agent = {
        enable = lib.mkDefault true;
        enableSSHSupport = lib.mkDefault true;
      };
      # Enabling seahorse keyring
      seahorse = {
        enable = lib.mkDefault true;
      };
      dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "org/gnome/desktop/background" = {
                picture-uri = "file://${pkgs.xinuxWallpapers.xinux-orange.gnomeFilePath}";
                picture-uri-dark = "file://${pkgs.xinuxWallpapers.xinux-orange.gnomeFilePath}";
              };
              "org/gnome/desktop/screensaver" = {
                picture-uri = "file://${pkgs.xinuxWallpapers.xinux-orange.gnomeFilePath}";
              };
              "org/gnome/desktop/interface" = {
                icon-theme = "Papirus-Dark";
                show-battery-percentage = true;
                color-scheme = "prefer-dark";
                monospace-font-name = "JetBrainsMono Nerd Font 10";
              };
              "org/gnome/shell" = {
                # disable-user-extensions = false;
                enabled-extensions = [
                  "user-theme@gnome-shell-extensions.gcampax.github.com"
                  "dash-to-dock@micxgx.gmail.com"
                  "appindicatorsupport@rgcjonas.gmail.com"
                  "light-style@gnome-shell-extensions.gcampax.github.com"
                  "system-monitor@gnome-shell-extensions.gcampax.github.com"
                  "clipboard-indicator@tudmotu.com"
                ];
                favorite-apps = [
                  "org.gnome.Geary.desktop"
                  "org.gnome.Calendar.desktop"
                  "org.gnome.Nautilus.desktop"
                  "org.xinux.NixSoftwareCenter.desktop"
                  "org.xinux.XinuxModuleManager.desktop"
                  "uz.xinux.EIMZOManager.desktop"
                ];
              };
              "org/gnome/mutter" = {
                dynamic-workspaces = true;
                edge-tiling = true;
              };
              "org/gnome/desktop/datetime" = {
                automatic-timezone = true;
              };
              "org/gnome/tweaks" = {
                show-extensions-notice = false;
              };
              "org/gnome/desktop/wm/preferences" = {
                button-layout = "appmenu:minimize,maximize,close";
              };
              # Dash to dock for multiple monitors
              "org/gnome/shell/extensions/dash-to-dock" = {
                multi-monitor = true;
                apply-custom-theme = true;
                click-action = "minimize";
              };
              "org/gnome/desktop/wm/keybindings" = {
                move-to-monitor-left = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
                move-to-monitor-right = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
                move-to-workspace-left = [
                  "<Super><Shift>Left"
                  "<Shift><Control><Alt>Left"
                ];
                move-to-workspace-right = [
                  "<Super><Shift>Right"
                  "<Shift><Control><Alt>Right"
                ];
              };
              "org/gnome/desktop/peripherals/touchpad" = {
                click-method = "areas";
              };
            };
          }
        ];
      };
    };

    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      packages = with pkgs; [
        # An alternative popular Chinese font
        wqy_zenhei
        ubuntu-classic
        corefonts
        carlito
        vista-fonts
        vista-fonts-chs
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
        cantarell-fonts
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
      ];
    };

    environment.variables = {
      # Disable compositing mode in WebKitGTK
      # https://github.com/NixOS/nixpkgs/issues/32580
      WEBKIT_DISABLE_COMPOSITING_MODE = lib.mkDefault 1;
    };

    services.xserver.excludePackages = [ pkgs.xterm ];

    environment.gnome.excludePackages = [
      pkgs.xterm
      nixos-background-info
      pkgs.gnome-backgrounds
      pkgs.gnome-tour
      pkgs.epiphany
    ];

    environment.systemPackages =
      with pkgs;
      # Whatever minimal mode enabled keep these extensions
      [
        # Gnome extentions
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.appindicator
        gnomeExtensions.dash-to-dock

        # Application Icons
        papirus-icon-theme

        # Wallpapers
        xinuxWallpapers.xinux-ant
        xinuxWallpapers.xinux-blue-dark
        xinuxWallpapers.xinux-blue-light
        xinuxWallpapers.xinux-hill
        xinuxWallpapers.xinux-lake
        xinuxWallpapers.xinux-orange
        xinuxWallpapers.xinux-river
        xinuxWallpapers.xinux-sky
        xinuxWallpapers.xinux-wheel
      ]
      ++ lib.optional config.modules.gnome.gsconnect.enable gnomeExtensions.gsconnect;
  };
}
