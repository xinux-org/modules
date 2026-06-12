{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.container;
in
{
  options.modules.container = with lib.types; {
    enable = lib.mkOption {
      type = bool;
      default = false;
      example = true;
      description = "Enable containerization support for the system.";
    };

    provider = lib.mkOption {
      type = enum [
        "docker"
        "podman"
      ];
      default = "docker";
      example = "podman";
      description = "Backend to empower the containers.";
    };

    # templates = lib.mkOption {
    #   type = bool;
    #   default = false;
    #   example = true;
    #   description = "Pre-install template manager software/buddy.";
    # };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Setup basic containerization settings
      {
        boot.enableContainers = true;
        virtualisation.containers.enable = true;
      }

      # If user chose docker as option
      (lib.mkIf (cfg.provider == "docker") {
        virtualisation.docker = {
          enable = true;
          daemon.settings = {
            experimental = true;
            default-address-pools = [
              {
                base = "172.30.0.0/16";
                size = 24;
              }
            ];
          };
        };

        users.groups.docker.members =
          builtins.attrValues config.users.users
          |> builtins.filter (attr: attr.isNormalUser)
          |> map (u: u.name);
      })

      # If user chose podman as option
      (lib.mkIf (cfg.provider == "podman") {
        virtualisation.podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        users.groups.podman.members =
          builtins.attrValues config.users.users
          |> builtins.filter (attr: attr.isNormalUser)
          |> map (u: u.name);
      })

      # If user chose podman as option
      # (lib.mkIf cfg.templates {
      #   environment.systemPackages = [
      #     pkgs.bleur
      #   ];
      # })
    ]
  );
}
