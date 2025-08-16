{osConfig, ...}: let
  hostSpecificImports =
    if osConfig.networking.hostName == "bunk"
    then [
      ./bunkmod.nix
    ]
    else [
      ./kimamod.nix
    ];
in {
  imports = hostSpecificImports;
}
