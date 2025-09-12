{
  lib,
  config,
  options,
  pkgs,
  ...
}: let
  nixos-background-info = pkgs.stdenv.mkDerivation {name = "nixos-background-info";};
  xinux-background-info = pkgs.writeTextFile rec {
    name = "xinux-background-info";
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
      <wallpapers>
        <wallpaper deleted="false">
          <name>Blobs</name>
          <filename>${pkgs.nixos-artwork.wallpapers.nineish.gnomeFilePath}</filename>
          <filename-dark>${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}</filename-dark>
          <options>zoom</options>
          <shade_type>solid</shade_type>
          <pcolor>#3a4ba0</pcolor>
          <scolor>#2f302f</scolor>
        </wallpaper>
      </wallpapers>
    '';
    destination = "/share/gnome-background-properties/xinux.xml";
  };
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
        picture-uri='file://${pkgs.nixos-artwork.wallpapers.nineish.gnomeFilePath}'
        picture-uri-dark='file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}'

        [org.gnome.desktop.screensaver]
        picture-uri='file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}'

        [org.gnome.desktop.interface]
        color-scheme='prefer-dark'

        [org.gnome.shell]
        disable-user-extensions=false

        [org.gnome.shell]
        enabled-extensions=['user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'appindicatorsupport@rgcjonas.gmail.com', 'light-style@gnome-shell-extensions.gcampax.github.com', 'system-monitor@gnome-shell-extensions.gcampax.github.com']

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
      noto-fonts-emoji
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

    environment.systemPackages = [
      xinux-background-info

      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.dash-to-dock
      pkgs.gnomeExtensions.gsconnect

      pkgs.papirus-icon-theme
    ];
  };
}
