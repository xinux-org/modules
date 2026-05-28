{
  description = "Xinux Modules";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-unstable&shallow=1";

    # Xinux
    xin = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xin?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-settings = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/settings?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/software-center?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-module-manager = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/module-manager?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    e-imzo-manager = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/e-imzo-manager?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-tour = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-tour?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-wallpaper = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/wallpaper?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Uzinfocom
    bleur = {
      url = "git+https://git.oss.uzinfocom.uz/bleur/bleur?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Kernels
    cachyos-kernel.url = "git+https://git.oss.uzinfocom.uz/mirrors/nix-cachyos-kernel?ref=master&shallow=1";

    # Custom software
    mac-style-plymouth = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-plymouth-theme?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uz-xkb = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/uzbek-linux-keyboard?shallow=1";
      flake = false;
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
