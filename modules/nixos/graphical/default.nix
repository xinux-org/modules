{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.graphical;

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  options.modules.graphical = with types; {
    enable = mkEnableOption "Xinux default graphical configurations (not including DE)";

    provider = mkOption {
      type = listOf (enum [
        "intel"
        "nvidia"
        "amdgpu"
        "modesetting"
        "fbdev"
      ]);
      default = [
        "modesetting"
        "fbdev"
      ];
      description = "Graphical driver to be added to the host system.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Enable fwupd
      services.fwupd.enable = lib.mkDefault true;

      # Add opengl/vulkan support
      hardware.graphics = {
        enable = lib.mkDefault true;
        enable32Bit = lib.mkDefault (config.hardware.graphics.enable && pkgs.stdenv.hostPlatform.isx86);
      };

      services.xserver.videoDrivers = cfg.provider;
    }

    # if the list includes intel in the list
    (lib.mkIf (builtins.elem "intel" cfg.provider) {
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
    (lib.mkIf (builtins.elem "nvidia" cfg.provider) {
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
    (lib.mkIf (config.hardware.nvidia.prime.offload.enable && cfg.enable) {
      environment.systemPackages = [ nvidia-offload ];
    })

    # if the list includes amdgpu in the list
    (lib.mkIf (builtins.elem "amdgpu" cfg.provider) {
      hardware.amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        zluda.enable = true;
      };
    })
  ]);
}
