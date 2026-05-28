{ inputs, ... }:
let
  exclusion = [
    "meta"
    "efiboot"
    "biosboot"
  ];
  modules =
    builtins.attrNames inputs.self.nixosModules
    |> builtins.filter (m: !(builtins.elem m exclusion))
    |> map (m: inputs.self.nixosModules.${m});
in
{
  imports = modules;
}
