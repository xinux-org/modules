{
  config,
  lib,
  ...
}:
let
  # Things to be removed from passing list
  exclusion = [
    # Remove boot options as they are appended on user side
    "efiboot"
    "biosboot"
  ];
in
{
  config = {
    environment.etc = lib.mkMerge [
      (
        builtins.readDir ./..
        |> lib.mapAttrs' (name: value: lib.nameValuePair "xinux-modules/${name}/module.yml" name)
        |> lib.filterAttrs (n: v: lib.hasAttr "module.yml" (builtins.readDir ../${v}))
        |> builtins.mapAttrs (name: path: { source = ../${path}/module.yml; })
      )
      {
        "xinux-modules/modules.json".text =
          builtins.readDir ./..
          |> lib.mapAttrs' (name: value: lib.nameValuePair "xinux-modules/${name}/module.yml" name)
          |> lib.filterAttrs (n: v: lib.hasAttr "module.yml" (builtins.readDir ../${v}))
          |> builtins.attrValues
          |> builtins.filter (m: !(builtins.elem m exclusion))
          # Convert to parsable module list
          |> map (n: "xinux-modules.nixosModules.${n}")
          |> builtins.toJSON;
      }
    ];
  };
}
