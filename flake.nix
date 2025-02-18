{
  description = "Xinux Modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Snowflake provided

    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    xinux-lib = {
      url = "github:xinux-org/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.xinux-lib.mkFlake {
      inherit inputs;
      channels-config.allowUnfree = true;
      src = ./.;
    };
}
