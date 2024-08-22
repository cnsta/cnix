{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.devtools.nixvim.plugins.rustaceanvim;
in {
  options.modules.devtools.nixvim.plugins.rustaceanvim = {
    enable = mkEnableOption "Whether to enable rustaceanvim.";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        rustaceanvim.enable = true;
      };
    };
  };
}
