{
  description = "Xinux Modules";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-unstable&shallow=1";

    # Xinux Package Manager
    xin.url = "git+https://git.oss.uzinfocom.uz/xinux/xin?ref=main&shallow=1";

    # New Xinux Settings app
    xinux-settings.url = "git+https://git.oss.uzinfocom.uz/xinux/settings?ref=main&shallow=1";

    # Software Center
    nix-software-center.url = "git+https://git.oss.uzinfocom.uz/xinux/software-center?ref=main&shallow=1";

    # Module Manager
    xinux-module-manager.url = "git+https://git.oss.uzinfocom.uz/xinux/module-manager?ref=main&shallow=1";

    # E-IMZO Manager
    e-imzo-manager.url = "git+https://git.oss.uzinfocom.uz/xinux/e-imzo-manager?ref=main&shallow=1";

    # Xinux Tour app
    xinux-tour.url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-tour?ref=main&shallow=1";

    # Nix Library
    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wallpapers
    xinux-wallpaper.url = "git+https://git.oss.uzinfocom.uz/xinux/wallpaper?ref=main&shallow=1";

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
    relago.url = "git+https://git.oss.uzinfocom.uz/xinux/relago?ref=main";
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
        # Allow NVIDIA's prop. software
        nvidia.acceptLicense = true;
      };

      # Source code
      src = ./.;

      # Extra nix flags to set
      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixfmt-tree;
      };

      # Default shell environment
      alias.shells.default = "modules";

      systems.modules.nixos = with inputs; [
        relago.nixosModules.relago
      ];

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
