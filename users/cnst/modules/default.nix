{osConfig, ...}: let
  hostSpecificImports =
    if osConfig.networking.hostName == "sobotka"
    then [
      ./sobotkamod.nix
    ]
    else if osConfig.networking.hostName == "bunk"
    then [
      ./bunkmod.nix
    ]
    else [
      ./kimamod.nix
    ];
in {
  imports = hostSpecificImports;
}
