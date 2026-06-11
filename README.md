# Xinux modules

## Features

- GNOME
  - Move a window to a different workspace. `Super` + `Shift` `Left/Right`
  - [Papirus theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- Packages
  - [e-imzo-manager](https://git.oss.uzinfocom.uz/xinux/e-imzo-manager)
  - [software-center](https://git.oss.uzinfocom.uz/xinux/software-center)
  - [module-manager](https://git.oss.uzinfocom.uz/xinux/module-manager)
  - [Xinux tour](https://git.oss.uzinfocom.uz/xinux/xinux-tour)
  - [settings (WIP)](https://git.oss.uzinfocom.uz/xinux/settings)
- Additions
  - biosboot/efiboot modules
    - [Xinux grub bootloader](https://git.oss.uzinfocom.uz/xinux/bootloader-theme)
    - [Xinux Plymouth Theme](https://git.oss.uzinfocom.uz/xinux/xinux-plymouth-theme)
  - [Wallpapers](https://git.oss.uzinfocom.uz/xinux/modules/src/branch/main/.forgejo/assets/wallpapers)
  - [Uzbek linux keyboard](https://github.com/itsbilolbek/uzbek-linux-keyboard)
  - Security and high privacy DNS by quad9 & AdGuard by default
  - Uzbek language support by Xinux maintainers: [platform](https://l10n.gnome.org/teams/uz/#lang-uz)
  - Font pack. Microsoft fonts included
  - Latest stable linux karnel
  - [sudo-rs](https://github.com/trifectatechfoundation/sudo-rs)
  - Binary [cache server](https://hydra.xinux.uz/) hosted within TAS-IX network
  - Hunspell spell checker on system and firefox browser
- Extension modules
  - Developer tools (Docker, Podman, Bluer templates)
  - Gaming (Steam, Aagl)
  - Intel, Amd, Nvidia nix configs
  - Various karnel options (zen, hardened, libre, stable, latest)
  - Shell (zsh, starship, rust core-utils)
  - Package managers (flathub, appimage
- [Self hosted VCS](https://git.oss.uzinfocom.uz/explore/repos). No github rate limit

## How to install?

Add flake.nix input

```nix
inputs = {
  xinux-modules = {
    url = "git+https://git.oss.uzinfocom.uz/xinux/modules?ref=main&shallow=1";
  };
  nix-data = {
    url = "git+https://git.oss.uzinfocom.uz/xinux/nix-data?ref=main&shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Add options into configuration.nix manually

```nix
{inputs, ...} {
imports = [
  inputs.self.nix-data.nixosModules.nix-data
  inputs.self.xinux-modules.nixosModules.efiboot # or biosboot
  inputs.self.xinux-modules.nixosModules.branding
  inputs.self.xinux-modules.nixosModules.gnome
  inputs.self.xinux-modules.nixosModules.developer
  inputs.self.xinux-modules.nixosModules.kernel
  inputs.self.xinux-modules.nixosModules.graphical
  inputs.self.xinux-modules.nixosModules.shell
  inputs.self.xinux-modules.nixosModules.gaming
  inputs.self.xinux-modules.nixosModules.networking
  inputs.self.xinux-modules.nixosModules.packagemanagers
  inputs.self.xinux-modules.nixosModules.pipewire
  inputs.self.xinux-modules.nixosModules.printing
  inputs.self.xinux-modules.nixosModules.metadata
  inputs.self.xinux-modules.nixosModules.xinux
];
  # Documentation: https://snowfall.org/reference/lib/
  programs.nix-data = {
    enable = true;
    systemconfig = "/etc/nixos/systems/@ARCH@/@HOSTNAME@/default.nix";
    flake = "/etc/nixos/flake.nix";
    flakearg = "@HOSTNAME@";
  };
  # the rest of your config
}
```

if you want all options then instead import meta module

```nix
imports = [
  inputs.self.nix-data.nixosModules.nix-data
  inputs.self.xinux-modules.nixosModules.efiboot # or biosboot
  inputs.self.xinux-modules.nixosModules.meta
  inputs.self.xinux-modules.nixosModules.xinux
];
```

## Thatʼs it, Happy `sudo nixos-rebuild switch --flake .`

## Code formatter and checkers

```bash
nix fmt .
nix flake check --system x86_64-linux --show-trace
nix repl :lf .

# geting narHash
nix flake prefetch "github:xinux-org/modules"
# getting rev
git rev-parse main
```
