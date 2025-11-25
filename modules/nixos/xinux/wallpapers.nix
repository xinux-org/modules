# Original from: https://github.com/NixOS/nixpkgs/blob/fce2ff01b1cfcdc6d711033069bc6e7f1057be43/pkgs/data/misc/nixos-artwork/wallpapers.nix
{
  lib,
  stdenv,
}: let
  mkNixBackground = {
    name,
    src,
    description,
    license ? lib.licenses.free,
  }: let
    pkg = stdenv.mkDerivation {
      inherit name src;

      dontUnpack = true;

      installPhase = ''
                runHook preInstall

                # GNOME
                mkdir -p $out/share/backgrounds/nixos
                ln -s $src $out/share/backgrounds/nixos/${baseNameOf src}

                mkdir -p $out/share/gnome-background-properties/
                cat <<EOF > $out/share/gnome-background-properties/${name}.xml
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
        <wallpapers>
          <wallpaper deleted="false">
            <name>${name}</name>
            <filename>${src}</filename>
            <options>zoom</options>
            <shade_type>solid</shade_type>
            <pcolor>#ffffff</pcolor>
            <scolor>#000000</scolor>
          </wallpaper>
        </wallpapers>
        EOF

                # TODO: is this path still needed?
                mkdir -p $out/share/artwork/gnome
                ln -s $src $out/share/artwork/gnome/${baseNameOf src}

                # KDE
                mkdir -p $out/share/wallpapers/${name}/contents/images
                ln -s $src $out/share/wallpapers/${name}/contents/images/${baseNameOf src}
                cat >>$out/share/wallpapers/${name}/metadata.desktop <<_EOF
        [Desktop Entry]
        Name=${name}
        X-KDE-PluginInfo-Name=${name}
        _EOF

                runHook postInstall
      '';

      passthru = {
        gnomeFilePath = "${pkg}/share/backgrounds/nixos/${baseNameOf src}";
        kdeFilePath = "${pkg}/share/wallpapers/${name}/contents/images/${baseNameOf src}";
      };

      meta = with lib; {
        inherit description license;
        homepage = "https://github.com/NixOS/nixos-artwork";
        platforms = platforms.all;
      };
    };
  in
    pkg;
in {
  xinux-blue-light = mkNixBackground {
    name = "xinux-blue-light";
    description = "xinux-blue-light";
    src = ../../../.github/assets/wallpapers/xinux-l.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-blue-dark = mkNixBackground {
    name = "xinux-blue-dark";
    description = "xinux-blue-dark";
    src = ../../../.github/assets/wallpapers/xinux-d.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-orange = mkNixBackground {
    name = "xinux-orange";
    description = "xinux-orange";
    src = ../../../.github/assets/wallpapers/xinux-orange.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-ant = mkNixBackground {
    name = "xinux-ant";
    description = "xinux-ant";
    src = ../../../.github/assets/wallpapers/ant.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-grass = mkNixBackground {
    name = "xinux-grass";
    description = "xinux-grass";
    src = ../../../.github/assets/wallpapers/grass.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-hill = mkNixBackground {
    name = "xinux-hill";
    description = "xinux-hill";
    src = ../../../.github/assets/wallpapers/hill.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-lake = mkNixBackground {
    name = "xinux-lake";
    description = "xinux-lake";
    src = ../../../.github/assets/wallpapers/lake.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-mountain = mkNixBackground {
    name = "xinux-mountain";
    description = "xinux-mountain";
    src = ../../../.github/assets/wallpapers/mountain.jpg;
    license = lib.licenses.cc-by-sa-40;
  };
  
  xinux-orange-flower = mkNixBackground {
    name = "xinux-orange-flower";
    description = "xinux-orange-flower";
    src = ../../../.github/assets/wallpapers/orange-flower.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-pink-flower = mkNixBackground {
    name = "xinux-pink-flower";
    description = "xinux-pink-flower";
    src = ../../../.github/assets/wallpapers/pink-flower.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-red-flower = mkNixBackground {
    name = "xinux-red-flower";
    description = "xinux-red-flower";
    src = ../../../.github/assets/wallpapers/red-flower.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-river = mkNixBackground {
    name = "xinux-river";
    description = "xinux-river";
    src = ../../../.github/assets/wallpapers/river.jpg;
    license = lib.licenses.cc-by-sa-40;
  };
  
  xinux-roses = mkNixBackground {
    name = "xinux-roses";
    description = "xinux-roses";
    src = ../../../.github/assets/wallpapers/roses.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-wheel = mkNixBackground {
    name = "xinux-wheel";
    description = "xinux-wheel";
    src = ../../../.github/assets/wallpapers/wheel.jpg;
    license = lib.licenses.cc-by-sa-40;
  };

  xinux-white-flower = mkNixBackground {
    name = "xinux-white-flower";
    description = "xinux-white-flower";
    src = ../../../.github/assets/wallpapers/xinux-white-flower.jpg;
    license = lib.licenses.cc-by-sa-40;
  };
  
}
