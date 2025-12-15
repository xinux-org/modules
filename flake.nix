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
