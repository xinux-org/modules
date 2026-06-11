{
  lib,
  ...
}:
{
  config = {
    services.printing.enable = lib.mkDefault true;
  };
}
