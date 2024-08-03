let
  shared = [
    ./bin
    ./etc
    ./nix
    ./srv
    ./usr/share
  ];

  adampad =
    shared
    ++ [
      ./bin/android
      ./srv/blueman
    ];
  cnix =
    shared
    ++ [
      ./usr/bin/gaming.nix
      ./usr/bin/android
      ./usr/bin/gimp
      ./usr/bin/inkscape
      ./srv/blueman
    ];
  toothpc =
    shared
    ++ [
      ./usr/bin/gaming.nix
    ];
in {
  inherit shared adampad cnix toothpc;
}
