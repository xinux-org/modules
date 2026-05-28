{ inputs, ... }:
let
  exclusion = [
    "meta"
    "efiboot"
    "biosboot"
  ];
  availableModules = builtins.attrNames inputs.self.nixosModules;
  modules =
    builtins.filter (m: !(builtins.elem m exclusion)) availableModules
    |> map (m: inputs.self.nixosModules.${m});
in
{
  imports = modules;
}
