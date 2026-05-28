# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{
  # Inputs from your flake.
  inputs,
  ...
}:

final: prev: {
  xinuxWallpapers = inputs.xinux-wallpaper.packages.${prev.stdenv.hostPlatform.system};
}
