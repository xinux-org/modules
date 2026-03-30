{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  nixos-background-info = pkgs.stdenv.mkDerivation { name = "nixos-background-info"; };
  xinux-wallpapers = lib.recurseIntoAttrs (pkgs.callPackage ./wallpapers.nix { });
in
{
  options.xinux.gnome = {
    enable = lib.mkEnableOption "Xinux GNOME configuration";
  };

  config = lib.mkIf config.xinux.gnome.enable {
    xinux.graphical.enable = true;
    services.desktopManager.gnome = {
      favoriteAppsOverride = mkDefault ''
        [org.gnome.shell]
        favorite-apps=[ 'firefox.desktop', 'org.gnome.Geary.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Nautilus.desktop', 'org.xinux.NixSoftwareCenter.desktop', 'org.xinux.XinuxModuleManager.desktop', 'uz.xinux.EIMZOManager.desktop' ]
      '';
      extraGSettingsOverrides = mkDefault ''
        [org.gnome.desktop.background]
        picture-uri='file://${xinux-wallpapers.xinux-orange.gnomeFilePath}'
        picture-uri-dark='file://${xinux-wallpapers.xinux-orange.gnomeFilePath}'

        [org.gnome.desktop.screensaver]
        picture-uri='file://${xinux-wallpapers.xinux-orange.gnomeFilePath}'

        [org.gnome.desktop.interface]
        color-scheme='prefer-dark'
        icon-theme='Papirus-Dark'
        show-battery-percentage=true
        color-scheme='default'
        monospace-font-name='JetBrainsMono Nerd Font 10'

        [org.gnome.shell]
        disable-user-extensions=false

        [org.gnome.shell]
        enabled-extensions=['user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'appindicatorsupport@rgcjonas.gmail.com', 'light-style@gnome-shell-extensions.gcampax.github.com', 'system-monitor@gnome-shell-extensions.gcampax.github.com', 'clipboard-indicator@tudmotu.com']

        [org.gnome.mutter]
        dynamic-workspaces=true
        edge-tiling=true

        [org.gnome.desktop.datetime]
        automatic-timezone=true

        [org.gnome.tweaks]
        show-extensions-notice=false

        [org.gnome.desktop.wm.preferences]
        button-layout='appmenu:minimize,maximize,close'

        # Dash to dock for multiple monitors
        [org.gnome.shell.extensions.dash-to-dock]
        multi-monitor=true
        apply-custom-theme=true
        click-action='minimize'

        [org.gnome.desktop.wm.keybindings]
        move-to-monitor-left=@as []
        move-to-monitor-right=@as []
        move-to-workspace-left=['<Super><Shift>Left', '<Shift><Control><Alt>Left']
        move-to-workspace-right=['<Super><Shift>Right', '<Shift><Control><Alt>Right']

        [org.gnome.desktop.peripherals.touchpad]
        click-method='areas'
      '';
      extraGSettingsOverridePackages = mkDefault [
        pkgs.gsettings-desktop-schemas
        pkgs.gnome-shell
      ];
    };

    # Setting daemons
    services = {
      # Udev daemon management
      udev.packages = with pkgs; mkDefault [ gnome-settings-daemon ];
    };

    programs = mkDefault {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      # Enabling seahorse keyring
      seahorse = {
        enable = true;
      };
    };

    fonts.packages =
      with pkgs;
      mkDefault [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        nerd-fonts.jetbrains-mono
      ];

    environment.variables = mkDefault {
      # Disable compositing mode in WebKitGTK
      # https://github.com/NixOS/nixpkgs/issues/32580
      WEBKIT_DISABLE_COMPOSITING_MODE = 1;
    };

    services.xserver.excludePackages = mkDefault [ pkgs.xterm ];

    environment.gnome.excludePackages = mkDefault [
      pkgs.xterm
      nixos-background-info
      pkgs.gnome-backgrounds
      pkgs.gnome-tour
    ];

    environment.systemPackages =
      # Whatever minimal mode enabled keep these extensions
      [
        pkgs.gnomeExtensions.appindicator
        pkgs.gnomeExtensions.dash-to-dock
        pkgs.papirus-icon-theme

        # wallpapers
        xinux-wallpapers.xinux-blue-light
        xinux-wallpapers.xinux-blue-dark
        xinux-wallpapers.xinux-orange
        xinux-wallpapers.xinux-ant
        xinux-wallpapers.xinux-grass
        xinux-wallpapers.xinux-hill
        xinux-wallpapers.xinux-lake
        xinux-wallpapers.xinux-mountain
        xinux-wallpapers.xinux-orange-flower
        xinux-wallpapers.xinux-pink-flower
        xinux-wallpapers.xinux-red-flower
        xinux-wallpapers.xinux-river
        xinux-wallpapers.xinux-roses
        xinux-wallpapers.xinux-wheel
        xinux-wallpapers.xinux-white-flower
        xinux-wallpapers.xinux-sky
      ]
      ++ (lib.optionals (!config.modules.gnome.removeUtils.enable) [
        pkgs.gnomeExtensions.gsconnect
        pkgs.gnomeExtensions.clipboard-indicator
      ]);
  };
}
