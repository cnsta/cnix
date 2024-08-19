{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.neo-tree;
in
{
  options = {
    modules.devtools.neovim.plugins.neo-tree.enable = mkEnableOption "Enables Neo-tree plugin for Neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.neo-tree = {
        enable = true;

        closeIfLastWindow = true;
        window = {
          width = 30;
          autoExpandWidth = true;
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>n";
          action = ":Neotree action=focus reveal toggle<CR>";
          options.silent = true;
        }
      ];
    };
  };
}
