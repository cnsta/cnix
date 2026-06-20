{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem.treefmt.imports = [./treefmt.nix];
}
