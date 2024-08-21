{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.yanky;
in {
  options = {
    modules.devtools.nixvim.plugins.yanky.enable = mkEnableOption "Enables Yanky plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.yanky = {
      enable = true;
    };
  };
}
