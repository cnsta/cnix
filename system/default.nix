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
      ./opt/gaming.nix
      ./opt/android
      ./opt/gimp
      ./opt/inkscape
      ./srv/blueman
    ];
  toothpc =
    shared
    ++ [
      ./opt/gaming.nix
    ];
in {
  inherit shared adampad cnix toothpc;
}
