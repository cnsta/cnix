{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.home.devtools.nixvim.plugins.neo-tree;
in {
  options = {
    home.devtools.nixvim.plugins.neo-tree.enable = mkEnableOption "Enables neo-tree plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.neo-tree = {
        enable = true;

        closeIfLastWindow = true;
        window = {
          width = 30;
          # autoExpandWidth = true;
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>n";
          action = ":Neotree focus toggle<CR>";
          options.silent = true;
        }
      ];
    };
  };
}
