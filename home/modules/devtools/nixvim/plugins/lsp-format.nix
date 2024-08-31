{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.lsp-format;
in {
  options = {
    modules.devtools.nixvim.plugins.lsp-format = {
      enable = mkEnableOption "Enables LSP formatting support for nixvim";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lsp-format = {
      enable = true;

      lspServersToEnable = [
        "rustfmt"
        "prettier"
        "prettierd"
        "php-cs-fixer"
        "alejandra"
        "xmllint"
        "black"
        "yamlfmt"
        "stylua"
      ];
    };
  };
}
