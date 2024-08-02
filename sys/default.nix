let
  shared = [
    ./nixos
    ./etc
    ./bin
    ./srv
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
      ./bin/gaming.nix
      ./bin/android
      ./bin/gimp
      ./bin/inkscape
      ./srv/blueman
    ];
  toothpc =
    shared
    ++ [
      ./bin/gaming.nix
    ];
in {
  inherit shared adampad cnix toothpc;
}
