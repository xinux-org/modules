{
  lib,
  config,
  pkgs,
  ...
}: let
  nixos-background-info = pkgs.stdenv.mkDerivation {name = "nixos-background-info";};
in {

  options.xinux.gnome = {
    enable = lib.mkEnableOption "Xinux GNOME configuration";
  };

  config = lib.mkIf config.xinux.gnome.enable {
    xinux.graphical.enable = true;
    services.desktopManager.gnome = {
      favoriteAppsOverride = lib.mkDefault ''
        [org.gnome.shell]
        favorite-apps=[ 'firefox.desktop', 'org.gnome.Geary.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Nautilus.desktop', 'org.xinux.NixSoftwareCenter.desktop' ]
      '';
      extraGSettingsOverrides = ''
        [org.gnome.desktop.background]
        picture-uri='file://${config.xinux.wallpapers."xinux-orange"}'
        picture-uri-dark='file://${config.xinux.wallpapers."xinux-orange"}'

        [org.gnome.desktop.screensaver]
        picture-uri='file://${config.xinux.wallpapers."xinux-orange"}'

        [org.gnome.desktop.interface]
        color-scheme='prefer-dark'

        [org.gnome.shell]
        disable-user-extensions=false

        [org.gnome.shell]
        enabled-extensions=['user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'appindicatorsupport@rgcjonas.gmail.com', 'light-style@gnome-shell-extensions.gcampax.github.com', 'system-monitor@gnome-shell-extensions.gcampax.github.com', 'clipboard-indicator@tudmotu.com']

        [org.gnome.mutter]
        dynamic-workspaces=true

        [org.gnome.mutter]
        edge-tiling=true

        [org.gnome.desktop.interface]
        icon-theme='Papirus-Dark'

        [org.gnome.desktop.interface]
        color-scheme='default'

        [org.gnome.desktop.datetime]
        automatic-timezone=true

        [org.gnome.tweaks]
        show-extensions-notice=false

        [org.gnome.desktop.wm.preferences]
        button-layout='appmenu:minimize,maximize,close'

        [org.gnome.desktop.interface]
        monospace-font-name='JetBrainsMono Nerd Font 10'

        [org.gnome.shell.extensions.dash-to-dock]
        multi-monitor=true

        [org.gnome.shell.extensions.dash-to-dock]
        apply-custom-theme=true
      '';
      extraGSettingsOverridePackages = [
        pkgs.gsettings-desktop-schemas
        pkgs.gnome-shell
      ];
    };

    # Setting daemons
    services = {
      # Udev daemon management
      udev.packages = with pkgs; [gnome-settings-daemon];
    };

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      # Enabling seahorse keyring
      seahorse = {
        enable = true;
      };
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      nerd-fonts.jetbrains-mono
    ];

    environment.variables = {
      # Disable compositing mode in WebKitGTK
      # https://github.com/NixOS/nixpkgs/issues/32580
      WEBKIT_DISABLE_COMPOSITING_MODE = 1;
    };

    services.xserver.excludePackages = [pkgs.xterm];

    environment.gnome.excludePackages = [
      pkgs.xterm
      nixos-background-info
    ];

    environment.systemPackages = 
      # if minimal mode enabled keep these extensions
      (lib.optionals (!config.modules.gnome.removeUtils.enable) [
        pkgs.gnomeExtensions.appindicator
        pkgs.gnomeExtensions.dash-to-dock
        pkgs.papirus-icon-theme
      ])
      ++ [
        pkgs.gnomeExtensions.gsconnect
        pkgs.gnomeExtensions.clipboard-indicator
      ];
  };
}
