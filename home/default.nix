{
  self,
  inputs,
  ...
}: let
  # Get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  # Define the shared imports
  sharedImports = [
    ./opt/browsers/firefox
    ./etc
    ./bin
    ./opt
    ./srv
  ];

  # Define homeImports for each profile, including sharedImports
  homeImports = {
    "cnst@cnix" =
      sharedImports
      ++ [
        ./bin/hyprland/cnst
        ./usr/share/shell/cnst
        ./usr/share/git/cnst
        ./opt/sops
        ./profiles/cnst
      ];
    "adam@adampad" =
      sharedImports
      ++ [
        ./bin/hyprland/adam
        ./usr/share/shell/adam
        ./usr/share/git/cnst
        ./profiles/adam
      ];
    "toothpick@toothpc" =
      sharedImports
      ++ [
        ./bin/hyprland/toothpick
        ./usr/share/git/toothpick
        ./usr/share/shell/toothpick
        ./profiles/toothpick
      ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  # Function to create home configuration
  makeHomeConfiguration = modules:
    homeManagerConfiguration {
      inherit pkgs extraSpecialArgs modules;
    };
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = builtins.listToAttrs (map
      (name: {
        name = builtins.replaceStrings ["@"] ["_"] name;
        value = makeHomeConfiguration homeImports.${name};
      })
      (builtins.attrNames homeImports));
  };
}
