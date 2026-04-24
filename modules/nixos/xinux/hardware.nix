{
  lib,
  config,
  pkgs,
  ...
}:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  options.xinux.graphical = {
    enable = lib.mkEnableOption "Xinux default graphical configurations (not including DE)";
    gpu = lib.mkOption {
      type =
        with lib.types;
        listOf enum [
          "intel"
          "nvidia"
          "amdgpu"
        ];
    };

  };

  config = lib.mkMerge [
    (lib.mkIf (config.hardware.nvidia.prime.offload.enable && config.xinux.graphical.enable) {
      environment.systemPackages = [ nvidia-offload ];
    })
    (lib.mkIf config.xinux.graphical.enable {
      # Enable fwupd
      services.fwupd.enable = lib.mkDefault true;

      # Add opengl/vulkan support
      hardware.graphics = {
        enable = lib.mkDefault true;
        enable32Bit = lib.mkDefault (config.hardware.graphics.enable && pkgs.stdenv.hostPlatform.isx86);
      };
    })
  ];

}
