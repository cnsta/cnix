{
  self,
  inputs,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  sharedImports = [
    # ./etc
    "${self}/scripts"
    inputs.nvf.homeManagerModules.default
    self.nixosModules.home
    self.nixosModules.options
  ];

  homeImports = {
    "cnst@cnixtop" =
      sharedImports
      ++ [
        ./cnst
      ];
    "cnst@cnixpad" =
      sharedImports
      ++ [
        ./cnst
      ];
    "cnstlab@cnixlab" =
      sharedImports
      ++ [
        ./cnstlab
      ];
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
