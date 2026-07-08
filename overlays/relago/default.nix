{
  inputs,
  ...
}:

final: prev: {
  relego = inputs.relago.packages.${prev.stdenv.hostPlatform.system}.default;
}
