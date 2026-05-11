{
  description = "Xinux Modules";

  inputs = {
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-25.11&shallow=1";

    # Xinux
    xin = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xin?ref=release-25.11&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/software-center?ref=release-25.11&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-module-manager = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/module-manager?ref=release-25.11&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    e-imzo-manager = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/e-imzo-manager?ref=release-25.11&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-conf-editor = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/conf-editor?ref=release-25.11&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-tour = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-tour?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=release-25.11&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Custom software
    mac-style-plymouth = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xinux-plymouth-theme?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uz-xkb = {
      url = "github:itsbilolbek/uzbek-linux-keyboard";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.xinux-lib.mkFlake {
      inherit inputs;
      channels-config.allowUnfree = true;
      src = ./.;
      alias.shells.default = "modules";
      hydraJobs = inputs.self.packages.x86_64-linux;
    };
}
