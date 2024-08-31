{
  lib,
  config,
  pkgs,
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

      efmls-configs = {
        enable = true;

        toolPackages.mdformat = pkgs.mdformat.withPlugins (
          ps:
            with ps; [
              # TODO: broken with update of mdformat
              # mdformat-gfm
              mdformat-frontmatter
              mdformat-footnote
              mdformat-tables
              mdit-py-plugins
            ]
        );

        setup = {
          sh = {
            #linter = "shellcheck";
            formatter = "shfmt";
          };
          bash = {
            #linter = "shellcheck";
            formatter = "shfmt";
          };
          c = {
            linter = "cppcheck";
          };
          markdown = {
            formatter = [
              "cbfmt"
              "mdformat"
            ];
          };
          python = {
            formatter = "black";
          };
          nix = {
            formatter = "alejandra";
            linter = "statix";
          };
          lua = {
            formatter = "stylua";
          };
          html = {
            formatter = [
              "prettier"
            ];
          };
          htmldjango = {
            linter = "djlint";
          };
          json = {
            formatter = "prettier";
          };
          css = {
            formatter = "prettier";
          };
          scss = {
            formatter = "prettier";
          };
          ts = {
            formatter = "prettier";
          };
          gitcommit = {
            linter = "gitlint";
          };
          php = {
            formatter = "php_cs_fixer";
          };
          rust = {
            formatter = "rustfmt";
          };
          sql = {
            formatter = "sql-formatter";
          };
        };
      };
    };
  };
}
