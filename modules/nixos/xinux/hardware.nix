{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.xinux.graphical;
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
        listOf (enum [
          "intel"
          "nvidia"
          "amdgpu"
        ]);
      default = [
        "modesetting"
        "fbdev"
      ];
      description = "Graphical driver to be added to the host system.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.xinux.graphical.enable {
      # Enable fwupd
      services.fwupd.enable = lib.mkDefault true;

      # Add opengl/vulkan support
      hardware.graphics = {
        enable = lib.mkDefault true;
        enable32Bit = lib.mkDefault (config.hardware.graphics.enable && pkgs.stdenv.hostPlatform.isx86);
      };

      services.xserver.videoDrivers = cfg.gpu;
    })

    # if the list includes intel in the list
    (lib.mkIf (builtins.elem "intel" cfg.gpu) {
      # GPU (Intel)
      hardware.graphics = {
        extraPackages = with pkgs; [
          vpl-gpu-rt
          intel-media-driver
          intel-ocl
          intel-vaapi-driver
        ];
      };
    })

    # if the list includes nvidia in the list
    (lib.mkIf (builtins.elem "nvidia" cfg.gpu) {
      boot = {
        kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        kernelParams = [
          "nvidia-drm.modeset=1"
        ];
      };
      # List packages system hardware configuration
      hardware = {
        # GPU (Nvidia)
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.latest;
        };
      };
    })

    # NVIDIA offload support
    (lib.mkIf (config.hardware.nvidia.prime.offload.enable && config.xinux.graphical.enable) {
      environment.systemPackages = [ nvidia-offload ];
    })

    # if the list includes amdgpu in the list
    (lib.mkIf (builtins.elem "amdgpu" cfg.gpu) {
      hardware.amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        zluda.enable = true;
      };
    })
  ];

}
