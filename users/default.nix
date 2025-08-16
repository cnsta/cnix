{
  self,
  inputs,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  sharedImports = [
    "${self}/scripts"
    inputs.nvf.homeManagerModules.default
    self.nixosModules.home
  ];

  homeImports = {
    "cnst@kima" =
      sharedImports
      ++ [
        ./cnst
      ];
    "cnst@bunk" =
      sharedImports
      ++ [
        ./cnst
      ];
    # "cnst@sobotka" =
    #   sharedImports
    #   ++ [
    #     ./cnst
    #   ];
    # "cnst@ziggy" =
    #   sharedImports
    #   ++ [
    #     ./cnst
    #   ];
    "toothpick@toothpc" =
      sharedImports
      ++ [
        ./toothpick
      ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  makeHomeConfiguration = modules:
    homeManagerConfiguration {
      inherit pkgs extraSpecialArgs modules;
    };
in {
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
