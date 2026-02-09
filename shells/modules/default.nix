{
  lib,
  mkShell,
  stdenv,
  nixd,
  alejandra,
  statix,
  deadnix,
  nixfmt,
}:
mkShell {
  nativeBuildInputs = [
    nixd
    alejandra
    statix
    deadnix
    nixfmt
  ];
}
