{
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib; {
  options.xinux.graphical = {
    enable = mkEnableOption "Xinux default graphical configurations (not including DE)";
  };

  config = mkIf config.xinux.graphical.enable {
    # Enable fwupd
    services.fwupd.enable = mkDefault true;

    # Add opengl/vulkan support
    hardware.graphics = {
      enable = mkDefault true;
      enable32Bit = mkDefault (config.hardware.graphics.enable && pkgs.stdenv.hostPlatform.isx86);
    };
  };
}
