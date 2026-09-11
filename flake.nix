{
  description = "Xinux Modules";

  inputs = {
    systems.url = "github:nix-systems/default-linux";

    flake-utils = {
     url = "github:numtide/flake-utils";
     inputs.systems.follows = "systems";
    };
    
    # Nixpkgs
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-unstable&shallow=1";

    # Xinux Package Manager
    xin = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xin?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        libxinux.follows = "libxinux";
        xinux-lib.follows = "xinux-lib";
      };
    };

    # New Xinux Settings app
    xinux-settings = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/settings?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        xinux-lib.follows = "xinux-lib";
      };
    };

    # Software Center
    nix-software-center = { 
      url = "git+https://git.oss.uzinfocom.uz/xinux/software-center?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        xinux-lib.follows = "xinux-lib";
        git-hooks.follows = "xinux-lib/git-hooks";
        treefmt-nix.follows = "xinux-lib/treefmt-nix";
        nixos-appstream-data.inputs.flake-utils.follows = "flake-utils";
      };
    };

    # Module Manager
    xinux-module-manager = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/module-manager?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        xinux-lib.follows = "xinux-lib";
        git-hooks.follows = "xinux-lib/git-hooks";
        treefmt-nix.follows = "xinux-lib/treefmt-nix";
      };
    };

    # E-IMZO Manager
    e-imzo-manager = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/e-imzo-manager?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        xinux-lib.follows = "xinux-lib";
        git-hooks.follows = "xinux-lib/git-hooks";
        treefmt-nix.follows = "xinux-lib/treefmt-nix";
        nix-appimage.inputs = {
          flake-utils.follows = "flake-utils";
          flake-compat.follows = "xinux-lib/flake-compat";
        };
      };
    };

    # Xinux Tour app
    xinux-tour = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-tour?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Nix Library
    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils-plus.inputs.flake-utils.follows = "flake-utils";
        git-hooks.inputs.flake-compat.follows = "xinux-lib/flake-compat";
      };
    };

    libxinux = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/libxinux?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        xinux-lib.follows = "xinux-lib";
      };
    };

    # Wallpapers
    xinux-wallpaper = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/wallpaper?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "xinux-lib/flake-parts";
      };
    };

    # Template Buddy
    bleur = { 
      url = "git+https://git.oss.uzinfocom.uz/bleur/bleur?ref=main&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "xinux-lib/flake-parts";
      };
    };

    # Kernels
    cachyos-kernel = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/nix-cachyos-kernel?ref=master&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "xinux-lib/flake-parts";
        flake-compat.follows = "xinux-lib/flake-compat";
      };
    };

    # Custom software
    mac-style-plymouth = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-plymouth-theme?ref=master&shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Uzbek Keyboard Layout
    uz-xkb = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/uzbek-linux-keyboard?shallow=1";
      flake = false;
    };

    # Zen Browser
    zen-browser = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/zen-browser-flake?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Helium Browser
    helium = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/helium-browser-nix-flake?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.inputs.systems.follows = "systems";
      };
    };

    # An Anime Game Launcher
    aagl = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/aagl-gtk-on-nix?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "xinux-lib/flake-compat";
      };
    };

    # Bug reporter for Xinux
    relago = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/relago?ref=main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-parts.follows = "xinux-lib/flake-parts";
        git-hooks-nix.follows = "xinux-lib/git-hooks";
        treefmt-nix.follows = "xinux-lib/treefmt-nix";
      };
    };
  };

  outputs =
    inputs:
    # Let the xinux-lib/mkFlake manage
    inputs.xinux-lib.mkFlake {
      # For mkFlake parsing
      inherit inputs;
      supportedSystems = import inputs.systems;

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
