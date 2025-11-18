{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
with lib; let
  cfg = config.modules.xinux;
in {
  imports = [
    ./l10n.nix
    ./gnome.nix
    ./version.nix
    ./hardware.nix
    ./graphical.nix
    ./wallpapers.nix
  ];

  options.modules.xinux = with types; {
    nixSoftwareCenter.enable = mkOption {
      type = bool;
      default = true;
      description = "Enable Nix Software Center, a graphical software center for Nix";
    };
    nixosConfEditor.enable = mkOption {
      type = bool;
      default = true;
      description = "Enable NixOS Configuration Editor, a graphical editor for NixOS configurations";
    };
    xinuxModuleManager.enable = mkOption {
      type = bool;
      default = true;
      description = "Enable Xinux Module Manager, a graphical tool for managing Xinux modules";
    };
    binaryCompat.enable = mkOption {
      type = bool;
      default = false;
      description = "Enables FHS binary compatibility (may not work in all cases)";
    };
    eimzoIntegraion.enable = mkOption {
      type = bool;
      default = true;
      description = "Enable services and install software of E-IMZO for easier management of keys";
    };
  };
  config = mkMerge [
    (mkIf cfg.nixSoftwareCenter.enable {
      environment.systemPackages = with inputs; [
        nix-software-center.packages.${system}.nix-software-center
      ];
    })
    (mkIf cfg.nixosConfEditor.enable {
      environment.systemPackages = with inputs; [
        nixos-conf-editor.packages.${system}.nixos-conf-editor
      ];
    })
    (mkIf cfg.eimzoIntegraion.enable {
      services.e-imzo.enable = mkForce true;
      environment.systemPackages = with inputs; [
        e-imzo-manager.packages.${system}.default
      ];
    })
    (mkIf cfg.xinuxModuleManager.enable {
      environment.systemPackages = with inputs; [
        xinux-module-manager.packages.${system}.xinux-module-manager
      ];
    })
    (mkIf cfg.binaryCompat.enable {
      programs.nix-ld = {
        enable = mkDefault true;
        libraries = with pkgs; [
          acl
          attr
          bzip2
          curl
          libglvnd
          libsodium
          libssh
          libxml2
          mesa
          openssl
          stdenv.cc.cc
          systemd
          util-linux
          vulkan-loader
          xz
          zlib
          zstd
        ];
      };
      services.envfs.enable = mkDefault true;
    })
    {
      xinux.osInfo.enable = mkDefault true;
      xinux.gnome.enable = mkDefault true;

      environment.systemPackages = [
        inputs.xin.packages.${system}.xin
        pkgs.git # For rebuiling with github flakes
        pkgs.firefox
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      programs.mtr.enable = mkDefault true;
      programs.gnupg.agent = {
        enable = mkDefault true;
        enableSSHSupport = mkDefault true;
      };

      # Reasonable Defaults
      nix =
        {
          settings =
            {
              experimental-features = ["nix-command" "flakes" "pipe-operators"];
              substituters = [
                "https://cache.xinux.uz/"
                "https://cache.nixos.org/"
              ];
              trusted-public-keys = [
                "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0=" # xinux
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" # nixos
              ];
            }
            // (mapAttrsRecursive (_: mkDefault) {
              connect-timeout = 5;
              log-lines = 25;
              min-free = 128000000;
              max-free = 1000000000;
              fallback = true;
              warn-dirty = false;
              auto-optimise-store = true;
            });
        }
        // (mapAttrsRecursive (_: mkDefault) {
          linkInputs = true;
          generateNixPathFromInputs = true;
          generateRegistryFromInputs = true;
        });
    }
  ];
}
