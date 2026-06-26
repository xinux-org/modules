{
  inputs,
  pkgs,
  ...
}:
pkgs.testers.runNixOSTest {
  name = "Xinux cachyos karnel config test";

  nodes.machine =
    { ... }:
    {
      imports = with inputs.self; [
        nixosModules.efiboot
        nixosModules.meta
        ./configuration.nix
      ];
    };

  node = {
    # since we are using an overlay, we must make pkgs writable
    pkgsReadOnly = false;

    specialArgs = { inherit inputs; };
  };

  # disable only when working on testScript
  skipTypeCheck = true;

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("uname -a")
    machine.succeed("echo Modules succesfully tested")
  '';
}
