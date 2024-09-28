{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.modules.nix.nh;
in {
  options = {
    modules.nix.nh = {
      enable = mkEnableOption "Enables nix helper";
      clean = {
        enable = mkEnableOption "Enables nix helper cleaning";
        extraArgs = mkOption {
          type = lib.types.str;
          description = "Extra arguments for the clean command";
          default = "";
        };
      };
    };
  };
  config = mkIf cfg.enable {
    programs = {
      nh = {
        enable = cfg.enable;
        clean = {
          enable = cfg.clean.enable;
          extraArgs = cfg.clean.extraArgs;
        };
      };
    };
  };
}
