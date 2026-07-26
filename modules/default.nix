{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.modules];

  options.flake.lib = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
    description = "Repo-local helpers.";
  };

  config.flake = {
    lib.clib = import ../lib {
      inherit (inputs.nixpkgs) lib;
      hosts = import ../hosts/registry.nix;
    };
    modules.nixos = {
      programs.imports = [./programs];
      services.imports = [./services];
      server.imports = [./server];
      settings.imports = [./settings];
    };
  };
}
