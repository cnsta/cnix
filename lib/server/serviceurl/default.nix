{
  lib,
  config,
  ...
}: let
  mkServiceUrl' = import ./serviceurl.nix {inherit config;};
in {
  options.clib = {
    server = {
      mkServiceUrl = lib.mkOption {
        type = lib.types.function;
        readOnly = true;
        description = "Helper function to generate a service URL.";
      };
    };
  };

  config.clib = {
    server = {
      mkServiceUrl = mkServiceUrl';
    };
  };
}
