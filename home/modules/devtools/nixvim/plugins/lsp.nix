{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.lsp;
in {
  options = {
    userModules.devtools.nixvim.plugins.lsp = {
      enable = mkEnableOption "Enables LSP support for nixvim";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      lsp-format = {
        enable = true;
        lspServersToEnable = [
          "rust-analyzer"
        ];
      };
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };

        servers = {
          # Average webdev LSPs
          cssls.enable = true; # CSS
          tailwindcss.enable = true; # TailwindCSS
          html.enable = true; # HTML
          astro.enable = true; # AstroJS
          phpactor.enable = true; # PHP
          svelte.enable = false; # Svelte
          vuels.enable = false; # Vue
          pyright.enable = true;
          marksman.enable = true;
          nixd.enable = true;
          dockerls.enable = true;
          bashls.enable = true;
          clangd.enable = true;
          csharp-ls.enable = true;
          yamlls.enable = true;
          lua-ls = {
            enable = true;
            settings = {
              telemetry.enable = false;
              diagnostics = {
                globals = ["vim"];
              };
            };
          };
          tsserver = {
            enable = false; # TS/JS
          };
        };
      };
    };
  };
}
