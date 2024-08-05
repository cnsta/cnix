# yes, this is also yanked from, you guessed it, fufexan.
let
  shared = [
    ./bin
    ./etc
    ./nix
    ./srv
    ./usr/share
    ./opt/microfetch
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
      ./opt/agenix
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
