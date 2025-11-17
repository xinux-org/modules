# Original from: uzinfocom-org/instances
{
  pkgs,
  lib,
  ...
}: let
  wallpapers = [
    {
      name = "blob";
      light = pkgs.nixos-artwork.wallpapers.nineish.gnomeFilePath;
      dark = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
    }
    {
      name = "xinux-blue";
      light = ../../../.github/assets/wallpapers/xinux-l.jpg;
      dark = ../../../.github/assets/wallpapers/xinux-d.jpg;
    }
    {
      name = "xinux-orange";
      light = ../../../.github/assets/wallpapers/xinux-orange.jpg;
      dark = ../../../.github/assets/wallpapers/xinux-orange.jpg;
    }
  ];
  mkWallpaper = i:
    pkgs.writeTextFile {
      name = "${i.name}";
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
        <wallpapers>
          <wallpaper deleted="false">
            <name>Blobs</name>
            <filename>${i.light}</filename>
            <filename-dark>${i.dark}</filename-dark>
            <options>zoom</options>
            <shade_type>solid</shade_type>
            <pcolor>#3a4ba0</pcolor>
            <scolor>#2f302f</scolor>
          </wallpaper>
        </wallpapers>
      '';
      destination = "/share/gnome-background-properties/${i.name}.xml";
    };

  mkWallpapers = builtins.listToAttrs (builtins.map (wp: {
      name = wp.name;
      value = mkWallpaper wp;
    })
    wallpapers);
  # imagination:
  # [ { name = "foo"; value = pkgs.writeTextFile{}; }
  #   { name = "bar"; value = pkgs.writeTextFile{}; }
  #   { name = "bar"; value = pkgs.writeTextFile{}; }
  # ] -> {xinux-orange = pkgs.writeTextFile {}}; { xinux-orange = pkgs.writeTextFile {};}
in {
  options.xinux.wallpapers = lib.mkOption {
    type = lib.types.listOf lib.types.path;
    default = {};
    example = {
      xinux-orange = pkgs.writeTextFile {};
      xinux-blue = pkgs.writeTextFile {};
    };
    description = "A set of custom wallpapers";
  };

  config = {
    xinux.wallpapers = mkWallpapers;

    environment.systemPackages = builtins.attrValues mkWallpapers; # [pkgs.writeTextFile{} pkgs.writeTextFile{}]
  };
}
