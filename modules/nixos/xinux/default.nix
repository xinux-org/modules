{
  options,
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
    ./gnome.nix
    ./graphical.nix
    ./hardware.nix
    ./version.nix
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
    eimzoIntegraion.enable = mkOption {
      type = bool;
      default = true;
      description = "Enable services and install software of E-IMZO for easier management of keys";
    };
    binaryCompat.enable = mkOption {
      type = bool;
      default = false;
      description = "Enables FHS binary compatibility (may not work in all cases)";
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
      services.e-imzo.enable = true;
      environment.systemPackages = with inputs; [
        e-imzo.packages.${system}.default
      ];
    })
    (mkIf cfg.nixSoftwareCenter.enable {
      environment.systemPackages = with inputs; [
        nix-software-center.packages.${system}.nix-software-center
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

      environment.systemPackages = with inputs; [
        xin.packages.${system}.xin
        pkgs.git # For rebuiling with github flakes
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
              experimental-features = ["nix-command" "flakes"];
              # substituters = [
              #   "https://cache.xinux.uz/"
              #   "https://cache.nixos.org/"
              # ];
              # trusted-public-keys = [
              #   "cache.xinux.uz-1:gX2Z53woXiIoLANfcC/Qp7vPPKVdK1sEa8MSiRhjj/M="
              # ];
              extra-substituters = [
                "https://cache.xinux.uz/"
              ];
              extra-trusted-public-keys = [
                "cache.xinux.uz-1:gX2Z53woXiIoLANfcC/Qp7vPPKVdK1sEa8MSiRhjj/M="
              ];
              # binaryCaches = [
              #   "https://cache.xinux.uz/"
              #   "https://cache.nixos.org/"
              # ];
              # binaryCachePublicKeys = [
              #   "cache.xinux.uz-1:gX2Z53woXiIoLANfcC/Qp7vPPKVdK1sEa8MSiRhjj/M="
              # ];
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
