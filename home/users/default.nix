{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "cnst@cnix" = [
      ../cnst.nix
      ./cnst
    ];
    "adam@adampad" = [
      ../adam.nix
      ./adam
    ];
    "toothpick@toothpc" = [
      ../toothpick.nix
      ./toothpick
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "cnst_cnix" = homeManagerConfiguration {
        modules = homeImports."cnst@cnix";
        inherit pkgs extraSpecialArgs;
      };

      "adam_adampad" = homeManagerConfiguration {
        modules = homeImports."adam@adampad";
        inherit pkgs extraSpecialArgs;
      };

      "toothpick_toothpc" = homeManagerConfiguration {
        modules = homeImports."toothpick@toothpc";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
