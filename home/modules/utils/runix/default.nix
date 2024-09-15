{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.runix;
in {
  imports = [
    inputs.runix.homeManagerModules.default
  ];
  options = {
    modules.utils.runix.enable = mkEnableOption "Enables runix";
  };
  config = mkIf cfg.enable {
    programs.runix = {
      enable = true;
    };
  };
}
