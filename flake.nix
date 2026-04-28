{
  description = "Xinux Modules";

  inputs = {
    # nixpkgs.url = "github:xinux-org/nixpkgs/nixos-unstable";
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-unstable&shallow=1";

    # Xinux provided

    xin = {
      # url = "github:xinux-org/xin";
      url = "git+https://git.oss.uzinfocom.uz/xinux/xin?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center = {
      # url = "github:xinux-org/software-center";
      url = "git+https://git.oss.uzinfocom.uz/xinux/software-center?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-module-manager = {
      url = "github:xinux-org/module-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-style-plymouth = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-plymouth-theme?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-tour = {
      url = "github:xinux-org/xinux-tour";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uz-xkb = {
      url = "github:itsbilolbek/uzbek-linux-keyboard";
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
      supportedSystems = [ "x86_64-linux" ];

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
      hydraJobs = inputs.self.packages.x86_64-linux;
    };
}
