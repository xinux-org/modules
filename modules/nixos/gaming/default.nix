{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.gaming;
in
{
  imports = [
    inputs.aagl.nixosModules.default
  ];

  options.modules.gaming = {
    steam = mkEnableOption "steam gaming platform";

    aagl = mkEnableOption "an anime game launcher";
  };

  config =
    with types;
    mkMerge [
      (mkIf cfg.steam {
        steam = {
          enable = config.games.steam;

          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];

          package = pkgs.steam.override {
            extraPkgs =
              pkgs': with pkgs'; [
                libXcursor
                libXi
                libXinerama
                libXScrnSaver
                libpng
                libpulseaudio
                libvorbis
                stdenv.cc.cc.lib # Provides libstdc++.so.6
                libkrb5
                keyutils
                bumblebee
                primus
                # Add other libraries as needed
              ];
          };
        };
      })

      (mkIf cfg.aagl {
        anime-game-launcher.enable = config.games.gayshit;
      })
    ];
}
