{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.yanky;
in {
  options = {
    userModules.devtools.nixvim.plugins.yanky.enable = mkEnableOption "Enables Yanky plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.yanky = {
      enable = true;
    };
  };
}
