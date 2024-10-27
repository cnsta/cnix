{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.home.devtools.nixvim.plugins.treesitter;
in {
  options = {
    home.devtools.nixvim.plugins = {
      treesitter.enable = mkEnableOption "Enables Treesitter plugin for nixvim";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        folding = true;
      };

      treesitter-refactor = mkIf cfg.enable {
        enable = true;
        highlightDefinitions = {
          enable = true;
          clearOnCursorMove = false;
        };
      };

      hmts = mkIf cfg.enable {
        enable = true;
      };
    };
  };
}
