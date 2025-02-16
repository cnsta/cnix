{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.accounts = {
    username = mkOption {
      type = types.str;
      default = "cnst";
      description = "Set the desired username";
    };
    hostname = mkOption {
      type = types.str;
      default = "cnix";
      description = "Set the desired hostname";
    };
  };
}
