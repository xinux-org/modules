{
  pkgs,
  ...
}:
{
  networking.hostName = "xinux";

  # Select internationalisation properties.
  modules.xinux.language = "uz_UZ.UTF-8";

  # Set the keyboard layout.
  services.xserver.xkb = {
    layout = "uz";
    variant = "latin";
  };
  console.useXkbConfig = true;

  users.users."xinux" = {
    isNormalUser = true;
    description = "a";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    htop
  ];

  system.stateVersion = "26.05";

  # programs.nix-data = {
  #   enable = true;
  #   systemconfig = "/etc/nixos/systems/x86_64-linux/xinux/default.nix";
  #   flake = "/etc/nixos/flake.nix";
  #   flakearg = "xinux";
  # };
}
