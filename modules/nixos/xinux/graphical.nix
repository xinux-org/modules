{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.xinux.graphical = {
    enable = lib.mkEnableOption "Xinux default graphical configurations (not including DE)";
  };

  config = lib.mkIf config.xinux.graphical.enable {
    # Enable fwupd
    services.fwupd.enable = lib.mkDefault true;

    # Add opengl/vulkan support
    hardware.graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault (config.hardware.graphics.enable && pkgs.stdenv.hostPlatform.isx86);
    };
  };
}
