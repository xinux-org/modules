{ inputs, ... }:
let
  exclusion = [
    "meta"
    "efiboot"
    "biosboot"
  ];

  modules =
    builtins.readDir ../.
    |> builtins.attrNames
    |> builtins.filter (m: !(builtins.elem m exclusion))
    |> map (m: inputs.self.nixosModules.${m});
in
{
  imports = modules;
}
