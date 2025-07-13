{osConfig, ...}: let
  hostSpecificImports =
    if osConfig.networking.hostName == "sobotka"
    then [
      ./sobotkamod.nix
      ./sobotkaopt.nix
    ]
    else if osConfig.networking.hostName == "bunk"
    then [
      ./bunkmod.nix
      ./bunkopt.nix
    ]
    else [
      ./kimamod.nix
      ./kimaopt.nix
    ];
in {
  imports = hostSpecificImports;
}
