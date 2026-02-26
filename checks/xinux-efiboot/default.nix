# source: https://discourse.nixos.org/t/nixostest-with-flake-configurations/11542/5
{
  inputs,
  pkgs,
  ...
}:
pkgs.testers.runNixOSTest {
  name = "Xinux efiboot config test";
  nodes.machine =
    { ... }:
    {
      imports = with inputs.self; [
        nixosModules.efiboot
        nixosModules.gnome
        nixosModules.kernel
        nixosModules.metadata
        nixosModules.networking
        nixosModules.packagemanagers
        nixosModules.pipewire
        nixosModules.printing
        nixosModules.xinux
        ./configuration.nix
      ];

      # virtually test nixosConfiguration.
      # I think we do not need this
      # fileSystems."/" = {
      #   # note this should be dynamic based on your disk
      #   device = "/dev/sdb3";
      #   fsType = "ext4";
      # };
    };

  node = {
    # since we are using an overlay, we must make pkgs writable
    pkgsReadOnly = false;

    specialArgs = { inherit inputs; };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("uname -a")
    machine.succeed("echo Modules succesfully tested")
  '';
}
