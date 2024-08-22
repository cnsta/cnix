{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.ai;
in {
  options = {
    modules.devtools.nixvim.plugins.ai.enable = mkEnableOption "Enables AI tools for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        chatgpt = {
          enable = true;
          settings = {
            api_key_cmd = "cat ${config.sops.secrets.openai_api_key.path}";
          };
        };
        copilot-chat.enable = true;

        copilot-lua = {
          enable = true;
          suggestion = {
            enabled = true;
            autoTrigger = true;
            keymap.accept = "<C-CR>";
          };
          panel.enabled = false;
        };
      };
      keymaps = [
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
        {
          action = "<cmd>ChatGPT<CR>";
          key = "<leader>ag";
          options = {
            desc = "Toggle ChatGPT";
          };
          mode = [
            "n"
          ];
        }
      ];
    };
  };
}
