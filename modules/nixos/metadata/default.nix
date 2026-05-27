{
  config,
  lib,
  ...
}:
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
          # Remove boot options as they are appended on user side
          |> builtins.filter (m: m != "efiboot")
          |> builtins.filter (m: m != "biosboot")
          # Convert to parsable module list
          |> map (n: "xinux-modules.nixosModules.${n}")
          |> builtins.toJSON;
      }
    ];
  };
}
