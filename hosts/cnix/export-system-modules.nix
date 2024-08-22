let
  modules = import ./modules.nix;
in
  builtins.toJSON modules
