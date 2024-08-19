{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.efm;
in
{
  options = {
    modules.devtools.neovim.plugins.efm.enable = mkEnableOption "Enables EFM LSP support for Neovim";
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
        lspServersToEnable = [ "efm" ];
      };

      efmls-configs.enable = true;
    };
  };
}
