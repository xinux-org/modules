{
  description = "Xinux Modules";

  inputs = {
    nixpkgs.url = "github:xinux-org/nixpkgs/nixos-25.11";

    # Xinux provided
    xinux-lib = {
      url = "github:xinux-org/lib/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xin = {
      url = "github:xinux-org/xin/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center = {
      url = "github:xinux-org/software-center/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xinux-module-manager = {
      url = "github:xinux-org/module-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-conf-editor = {
      url = "github:xinux-org/conf-editor/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    e-imzo-manager = {
      url = "github:xinux-org/e-imzo-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-style-plymouth = {
      url = "github:xinux-org/xinux-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.xinux-lib.mkFlake {
      inherit inputs;
      channels-config.allowUnfree = true;
      src = ./.;
      alias.shells.default = "modules";
      hydraJobs = inputs.self.packages.x86_64-linux;
    };
}
