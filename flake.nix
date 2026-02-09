{
  description = "Xinux Modules";

  inputs = {
    nixpkgs.url = "github:xinux-org/nixpkgs/nixos-unstable";

    # Xinux provided

    xin = {
      url = "github:xinux-org/xin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center = {
      url = "github:xinux-org/software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-module-manager = {
      url = "github:xinux-org/module-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-conf-editor = {
      url = "github:xinux-org/conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-lib = {
      url = "github:xinux-org/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    e-imzo-manager = {
      url = "github:xinux-org/e-imzo-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-style-plymouth = {
      url = "github:xinux-org/xinux-plymouth-theme";
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
  };

  outputs =
    inputs:
    # Let the xinux-lib/mkFlake manage
    inputs.xinux-lib.mkFlake {
      # For mkFlake parsing
      inherit inputs;

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
