{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.conform;
in {
  options = {
    userModules.devtools.nixvim.plugins.conform.enable = mkEnableOption "Enables Conform plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.conform = {
      enable = true;
      settings = {
        notify_on_error = true;
        formatters_by_ft = {
          html = ["prettierd" "prettier"];
          css = ["prettierd" "prettier"];
          javascript = ["prettierd" "prettier"];
          javascriptreact = ["prettierd" "prettier"];
          typescript = ["prettierd" "prettier"];
          typescriptreact = ["prettierd" "prettier"];
          python = ["black"];
          lua = ["stylua"];
          nix = ["alejandra"];
          markdown = ["prettierd" "prettier"];
          yaml = ["yamlfmt"];
          rust = ["rustfmt"];
          xml = ["xmllint"];
          php = ["php-cs-fixer"];
        };
        stop_after_first = true;
      };
    };
    home.packages = with pkgs; [
      prettierd
      yamlfmt
      libxml2Python
    ];
  };
}
