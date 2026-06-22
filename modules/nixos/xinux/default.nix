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
    (
      with lib;
      lib.doRename rec {
        from = [
          "modules"
          "xinux"
          "language"
        ];
        to = [
          "i18n"
          "defaultLocale"
        ];
        visible = false;
        warn = true;
        use = warnIf (oldestSupportedReleaseIsAtLeast 2511) "Obsolete option `${showOption from}' is used. It was replaced to `${showOption to}'.";
      }
    )

    ./l10n.nix
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
    libreofficePack.enable = lib.mkOption {
      type = bool;
      default = true;
      description = "Install LibreOffice document office suite";
    };
    browser = lib.mkOption {
      type = enum [
        "firefox"
        "web"
        "zen"
        "chrome"
        "chromium"
      ];
      default = "firefox";
      example = "web";
      description = "A browser of choice for the system.";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.nixSoftwareCenter.enable {
      environment.systemPackages = with pkgs; [
        nix-software-center
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
    (lib.mkIf cfg.libreofficePack.enable {
      environment.systemPackages = with pkgs; [
        libreoffice
      ];
    })

    # Browsers
    (lib.mkIf (cfg.browser == "firefox") {
      programs.firefox = {
        enable = true;
        preferences = {
          "spellchecker.dictionary_path" =
            let
              dictionary = pkgs.symlinkJoin {
                name = "firefox-hunspell-dicts";
                paths = with pkgs.hunspellDicts; [
                  en-us-large
                  ru-ru
                  uz-uz
                ];
              };
            in
            "${dictionary}/share/hunspell";

          # https://kb.mozillazine.org/Layout.spellcheckDefault
          "layout.spellcheckDefault" = 2;
        };
      };
    })
    (lib.mkIf (cfg.browser == "web") {
      environment.systemPackages = [ pkgs.epiphany ];
    })
    (lib.mkIf (cfg.browser == "zen") {
      environment.systemPackages = [
        inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
      ];
    })
    (lib.mkIf (cfg.browser == "chrome") {
      environment.systemPackages = [ pkgs.google-chrome ];
    })
    (lib.mkIf (cfg.browser == "chromium") {
      environment.systemPackages = [ pkgs.chromium ];
    })

    # FHS Nix Linking
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
      # Default sudo-rs for better security
      security = {
        sudo-rs.enable = lib.mkDefault true;
      };

      # Pre-installed packages
      environment.systemPackages = [
        inputs.xin.packages.${pkgs.stdenv.hostPlatform.system}.xin
        pkgs.git # For rebuiling with github flakes
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
          substituters = [
            "https://cache.xinux.uz/?priority=10"
          ];
          trusted-public-keys = [
            "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
          ];

          trusted-users =
            builtins.attrValues config.users.users
            |> builtins.filter (attr: attr.isNormalUser)
            |> map (u: u.name);
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

      nixpkgs.overlays = [
        inputs.cachyos-kernel.overlays.default
        inputs.xinux-wallpaper.overlays.default
      ];
    }
  ];
}
