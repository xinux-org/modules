{
  imagemagick,
  runCommand,
}:
runCommand "xinux-icon" {
  nativeBuildInputs = [imagemagick];
} ''
  for i in 16 24 48 64 96 128 256 512 1024; do
    mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
    magick -background none ${./xinux-icon.svg} -resize ''${i}x''${i} $out/share/icons/hicolor/''${i}x''${i}/apps/xinux.png
  done
  mkdir -p $out/share/icons/hicolor/scalable/apps
  cp ${./xinux-icon.svg} $out/share/icons/hicolor/scalable/apps/xinux.svg
''
