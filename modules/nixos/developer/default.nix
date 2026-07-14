{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.developer;

  users =
    builtins.attrValues config.users.users
    |> builtins.filter (attr: attr.isNormalUser)
    |> map (u: u.name);
in
{
  options.modules.developer = with lib.types; {
    android.enable = lib.mkOption {
      type = bool;
      default = false;
      example = true;
      description = "Set up pre-configured android development toolchain.";
    };

    templates = lib.mkOption {
      type = bool;
      default = false;
      example = true;
      description = "Pre-install template manager software/buddy.";
    };
  };

  config = lib.mkMerge [
    # Setup android toolchain
    (lib.mkIf cfg.android.enable {
      # Add all users to adb and kvm
      users.groups = {
        "kvm".members = users;
        "adbusers".members = users;
      };

      # Install android studio
      environment.systemPackages = [
        # Android Studio
        pkgs.android-studio
        pkgs.android-tools

        # Patched gradlew
        # TODO(@orzklv): maybe this should be in project shell.nix?
        (pkgs.buildFHSEnv {
          name = "android-sdk-env";
          targetPkgs =
            pkgs:
            (with pkgs; [
              androidenv.androidPkgs.androidsdk
              glibc
            ]);
          runScript = "bash";
        }).env
      ];
    })

    # If user chose podman as option
    (lib.mkIf cfg.templates {
      environment.systemPackages = [
        pkgs.bleur
      ];
    })
  ];
}
