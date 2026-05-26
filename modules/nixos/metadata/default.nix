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
          |> map (n: "xinux-modules.nixosModules.${n}")
          |> builtins.toJSON;
      }
    ];
  };
}
