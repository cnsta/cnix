{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.efm;
in {
  options = {
    modules.devtools.nixvim.plugins.efm.enable = mkEnableOption "Enables EFM LSP support for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      lsp.servers.efm = {
        enable = true;
        extraOptions.init_options = {
          documentFormatting = true;
          documentRangeFormatting = true;
          hover = true;
          documentSymbol = true;
          codeAction = true;
          completion = true;
        };
      };

      lsp-format = {
        enable = true;
        lspServersToEnable = ["efm"];
      };

      efmls-configs.enable = true;
    };
  };
}
