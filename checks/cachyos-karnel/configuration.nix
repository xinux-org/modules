{
  pkgs,
  ...
}:
{
  # CachyOS karnel test. This is more popular karnel option
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

  networking.hostName = "xinux";
  i18n.defaultLocale = "uz_UZ.UTF-8";
  console.useXkbConfig = true;

  users.users."cachy" = {
    isNormalUser = true;
    description = "cachy kernel test";
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
}
