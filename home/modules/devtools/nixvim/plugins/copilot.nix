{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.copilot;
in {
  options = {
    modules.devtools.nixvim.plugins.copilot.enable = mkEnableOption "Enables AI tools for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        copilot-chat = {
          enable = true;
        };
        copilot-lua = {
          enable = true;
          suggestion = {
            enabled = true;
            autoTrigger = true;
            keymap.accept = "<C-CR>";
          };
          panel.enabled = true;
        };
      };
      keymaps = [
        {
          action = "<cmd>lua local input = vim.fn.input('Quick Chat: '); if input ~= '' then require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer }) end<CR>";
          key = "<leader>qc";
          options = {
            desc = "CopilotChat - Quick chat";
          };
          mode = [
            "n"
          ];
        }
        {
          action = "<cmd>CopilotChatToggle<CR>";
          key = "<leader>ac";
          options = {
            desc = "Toggle Coilot chat";
          };
          mode = [
            "n"
          ];
        }
      ];
    };
  };
}
