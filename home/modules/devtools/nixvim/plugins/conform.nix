{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.conform-nvim;
in {
  options = {
    modules.devtools.nixvim.plugins.conform-nvim.enable = mkEnableOption "Enables Conform plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        formatters_by_ft = {
          liquidsoap = ["liquidsoap-prettier"];
          html = [["prettierd" "prettier"]];
          css = [["prettierd" "prettier"]];
          javascript = [["prettierd" "prettier"]];
          javascriptreact = [["prettierd" "prettier"]];
          typescript = [["prettierd" "prettier"]];
          typescriptreact = [["prettierd" "prettier"]];
          python = ["black"];
          lua = ["stylua"];
          nix = ["alejandra"];
          markdown = [["prettierd" "prettier"]];
          yaml = ["yamllint" "yamlfmt"];
        };
      };
    };
  };
}
