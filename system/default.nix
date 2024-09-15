let
  shared = [
    ./etc
    ./nix
    ./modules
  ];
  desktop = [
  ];
in {
  inherit shared desktop;
}
