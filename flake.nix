{
  description = "Xinux Modules";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-26.05&shallow=1";

    # Xinux Package Manager
    xin.url = "git+https://git.oss.uzinfocom.uz/xinux/xin?ref=main&shallow=1";

    # New Xinux Settings app
    xinux-settings.url = "git+https://git.oss.uzinfocom.uz/xinux/settings?ref=main&shallow=1";

    # Software Center
    nix-software-center.url = "git+https://git.oss.uzinfocom.uz/xinux/software-center?ref=release-26.05&shallow=1";

    # Module Manager
    xinux-module-manager.url = "git+https://git.oss.uzinfocom.uz/xinux/module-manager?ref=release-26.05&shallow=1";

    # E-IMZO Manager
    e-imzo-manager.url = "git+https://git.oss.uzinfocom.uz/xinux/e-imzo-manager?ref=release-26.05&shallow=1";

    # Xinux Tour app
    xinux-tour.url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-tour?ref=release-26.05&shallow=1";

    # Nix Library
    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=release-26.05&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wallpapers
    xinux-wallpaper.url = "git+https://git.oss.uzinfocom.uz/xinux/wallpaper?ref=release-26.05&shallow=1";

    # Template Buddy
    bleur.url = "git+https://git.oss.uzinfocom.uz/bleur/bleur?ref=main&shallow=1";

    # Kernels
    cachyos-kernel.url = "git+https://git.oss.uzinfocom.uz/mirrors/nix-cachyos-kernel?ref=master&shallow=1";

    # Custom software
    mac-style-plymouth.url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-plymouth-theme?ref=master&shallow=1";

    # Uzbek Keyboard Layout
    uz-xkb = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/uzbek-linux-keyboard?shallow=1";
      flake = false;
    };

    # Zen Browser
    zen-browser.url = "git+https://git.oss.uzinfocom.uz/mirrors/zen-browser-flake?shallow=1";

    # An Anime Game Launcher
    aagl.url = "git+https://git.oss.uzinfocom.uz/mirrors/aagl-gtk-on-nix?shallow=1";

    # Bug reporter for Xinux
    relago.url = "git+https://git.oss.uzinfocom.uz/xinux/relago?ref=release-26.05";
  };

  outputs =
    inputs:
    # Let the xinux-lib/mkFlake manage
    inputs.xinux-lib.mkFlake {
      # For mkFlake parsing
      inherit inputs;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Nixpkgs configs
      channels-config = {
        # Allow unfree software
        allowUnfree = true;
        # Allow unsupported packages
        allowUnsupportedSystem = true;
        # Allow all predications of unfree
        allowUnfreePredicate = _: true;
        # Allow broken packages
        allowBroken = true;
        # Allow NVIDIA's prop. software
        nvidia.acceptLicense = true;
        # Allow Android Studio license
        android_sdk.accept_license = true;
      };

      # Source code
      src = ./.;

      # Extra nix flags to set
      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixfmt-tree;
      };

      # Default shell environment
      alias.shells.default = "modules";

      systems.modules.nixos = with inputs; [ ];

      # Hydra jobs for building caches
      hydraJobs = {
        inherit (inputs.self.pkgs.x86_64-linux.nixpkgs)
          bleur
          e-imzo-manager
          nix-software-center
          xinux-module-manager
          xinux-settings
          xinux-tour
          ;
      };
    };
}
