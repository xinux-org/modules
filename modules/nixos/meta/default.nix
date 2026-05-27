{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    branding
    container
    # developer
    gnome
    graphical
    shell
    gaming
    kernel
    networking
    packagemanagers
    pipewire
    printing
    xinux
    metadata
  ];
}
