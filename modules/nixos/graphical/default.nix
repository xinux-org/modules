{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.graphical;
in
{
  imports = [ ./gpu.nix ];

  options.modules.graphical = with types; {
    enable = mkEnableOption "Xinux default graphical configurations (not including DE)";

    provider = mkOption {
      type = enum [
        "default"
        "nvidia"
        "amdgpu"
        "intel"
      ];
      default = "default";
      description = "The graphics card provider to install driver for.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      modules.gpu.enable = true;
    }

    (lib.mkIf (cfg.provider == "default") {
      modules.gpu.vendor = [
        "modesetting"
        "fbdev"
      ];
    })

    (lib.mkIf (cfg.provider == "intel") {
      modules.gpu.vendor = [ "intel" ];
    })

    (lib.mkIf (cfg.provider == "nvidia") {
      # can be combined with amd or intel
      modules.gpu.vendor = [
        "nvidia"
      ]
      ++ (optionals config.hardware.cpu.amd.updateMicrocode [ "amdgpu" ])
      ++ (optionals config.hardware.cpu.intel.updateMicrocode [ "intel" ]);
    })

    (lib.mkIf (cfg.provider == "amdgpu") {
      # can be combined with intel
      modules.gpu.vendor = [
        "amdgpu"
      ]
      ++ (optionals config.hardware.cpu.intel.updateMicrocode [ "intel" ]);
    })
  ]);
}
