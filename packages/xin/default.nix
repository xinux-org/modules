{
  inputs,
  pkgs,
}:
inputs.xin.packages.${pkgs.stdenv.hostPlatform.system}.xin
