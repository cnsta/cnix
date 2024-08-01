{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "cnst@cnix" = [
      ./core/gui/hypr/cnst.nix
      ./core/tui/git/cnst.nix
      ./core/tui/shell/cnst.nix
      ./core
      ./users/cnst
    ];
    "adam@adampad" = [
      ./core/gui/hypr/cnst.nix
      ./core/tui/git/cnst.nix
      ./core/tui/shell/adam.nix
      ./core
      ./users/adam
    ];
    "toothpick@toothpc" = [
      ./core/gui/hypr/toothpick.nix
      ./core/tui/git/toothpick.nix
      ./core/tui/shell/toothpick.nix
      ./core
      ./users/toothpick
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
