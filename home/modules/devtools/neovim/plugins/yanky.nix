{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.yanky;
in
{
  options = {
    modules.devtools.neovim.plugins.yanky.enable = mkEnableOption "Enables Yanky plugin for Neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.yanky = {
      enable = true;
    };
  };
}
