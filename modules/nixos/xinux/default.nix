{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.modules.xinux;
in
{
  imports = [
    ./l10n.nix
    ./gnome.nix
    ./debug.nix
    ./hardware.nix
  ];

  options.modules.xinux = with lib.types; {
    nixSoftwareCenter.enable = lib.mkOption {
      type = bool;
      default = true;
      description = "Enable Nix Software Center, a graphical software center for Nix";
    };
    xinuxModuleManager.enable = lib.mkOption {
      type = bool;
      default = true;
      description = "Enable Xinux Module Manager, a graphical tool for managing Xinux modules";
    };
    binaryCompat.enable = lib.mkOption {
      type = bool;
      default = false;
      description = "Enables FHS binary compatibility (may not work in all cases)";
    };
    eimzoIntegraion.enable = lib.mkOption {
      type = bool;
      default = false;
      description = "Enable services and install software of E-IMZO for easier management of keys";
    };
    language = lib.mkOption {
      type = enum [
        "uz_UZ.UTF-8"
        "en_US.UTF-8"
        "ru_RU.UTF-8"
      ];
      default = "uz_UZ.UTF-8";
      description = "set language";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.nixSoftwareCenter.enable {
      environment.systemPackages = with pkgs; [
        software-center
      ];
    })
    (lib.mkIf cfg.eimzoIntegraion.enable {
      services.e-imzo.enable = lib.mkDefault true;
      environment.systemPackages = with pkgs; [
        e-imzo-manager
      ];
    })
    (lib.mkIf cfg.xinuxModuleManager.enable {
      environment.systemPackages = with pkgs; [
        xinux-module-manager
      ];
    })
    (lib.mkIf (cfg.language == "uz_UZ.UTF-8") {
      i18n.defaultLocale = lib.mkDefault "uz_UZ.UTF-8";
    })
    (lib.mkIf (cfg.language == "en_US.UTF-8") {
      i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
    })
    (lib.mkIf (cfg.language == "ru_RU.UTF-8") {
      i18n.defaultLocale = lib.mkDefault "ru_RU.UTF-8";
    })
    (lib.mkIf cfg.binaryCompat.enable {
      programs.nix-ld = {
        enable = lib.mkDefault true;
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
      services.envfs.enable = lib.mkDefault true;
    })
    {
      xinux = {
        gnome.enable = lib.mkDefault true;
      };

      security = {
        sudo-rs.enable = lib.mkDefault true;
      };

      environment.systemPackages = [
        inputs.xin.packages.${system}.xin
        pkgs.git # For rebuiling with github flakes
        pkgs.firefox
      ];

      programs = {
        # Some programs need SUID wrappers, can be configured further or are
        # started in user sessions.
        mtr.enable = lib.mkDefault true;
      };

      # Generate nix inputs at etc
      environment.etc = (
        lib.mapAttrs' (name: value: {
          name = "nix/inputs/${name}";
          value = {
            source = value.outPath;
          };
        }) inputs
      );

      # Reasonable Defaults
      nix = {
        settings = {
          experimental-features = lib.mkDefault [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];
          substituters = lib.mkDefault [
            "https://cache.xinux.uz/"
            "https://cache.nixos.org/"
          ];
          trusted-public-keys = lib.mkDefault [
            "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0=" # xinux
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" # nixos
          ];
        }
        // (lib.mapAttrsRecursive (_: lib.mkDefault) {
          connect-timeout = 5;
          log-lines = 25;
          min-free = 128000000;
          max-free = 1000000000;
          fallback = true;
          warn-dirty = false;
          auto-optimise-store = true;
        });
      }
      // (lib.mapAttrsRecursive (_: lib.mkDefault) {
        # flake-plus-utils provided options
        # linkInputs = true;
        # generateNixPathFromInputs = true;
        # generateRegistryFromInputs = true;

        # Manually implemented nixPath and registry
        # Because flake-utils-plus options arent' working
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
        nixPath = [ "/etc/nix/inputs" ];
      });
    }
  ];
}
