{
  self,
  inputs,
  ...
}: let
  # Get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  # Define the shared imports
  sharedImports = [
    ./modules
    ./etc
    "${self}/.scripts"
  ];

  # Define homeImports for each user, including sharedImports
  homeImports = {
    "cnst@cnix" =
      sharedImports
      ++ [
        ./users/cnst
      ];
    "cnst@cnixpad" =
      sharedImports
      ++ [
        ./users/cnst
      ];
    "toothpick@toothpc" =
      sharedImports
      ++ [
        ./users/toothpick
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
