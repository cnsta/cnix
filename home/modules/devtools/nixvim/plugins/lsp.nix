{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.lsp;
in {
  options = {
    modules.devtools.nixvim.plugins.lsp = {
      enable = mkEnableOption "Enables LSP support for nixvim";
      servers = {
        cssls.enable = mkEnableOption "Enable CSS LSP";
        tailwindcss.enable = mkEnableOption "Enable TailwindCSS LSP";
        html.enable = mkEnableOption "Enable HTML LSP";
        astro.enable = mkEnableOption "Enable AstroJS LSP";
        phpactor.enable = mkEnableOption "Enable PHP LSP";
        svelte.enable = mkEnableOption "Enable Svelte LSP";
        vuels.enable = mkEnableOption "Enable Vue LSP";
        pyright.enable = mkEnableOption "Enable Python LSP";
        marksman.enable = mkEnableOption "Enable Markdown LSP";
        nixd.enable = mkEnableOption "Enable Nix LSP";
        dockerls.enable = mkEnableOption "Enable Docker LSP";
        bashls.enable = mkEnableOption "Enable Bash LSP";
        clangd.enable = mkEnableOption "Enable C/C++ LSP";
        csharp-ls.enable = mkEnableOption "Enable C# LSP";
        yamlls.enable = mkEnableOption "Enable YAML LSP";
        lua-ls.enable = mkEnableOption "Enable Lua LSP";
        tsserver.enable = mkEnableOption "Enable TypeScript/JavaScript LSP";
        rust-analyzer.enable = mkEnableOption "Enable Rust LSP";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lsp = {
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
        cssls = mkIf cfg.servers.cssls.enable {};
        tailwindcss = mkIf cfg.servers.tailwindcss.enable {};
        html = mkIf cfg.servers.html.enable {};
        astro = mkIf cfg.servers.astro.enable {};
        phpactor = mkIf cfg.servers.phpactor.enable {};
        svelte = mkIf cfg.servers.svelte.enable {};
        vuels = mkIf cfg.servers.vuels.enable {};
        pyright = mkIf cfg.servers.pyright.enable {};
        marksman = mkIf cfg.servers.marksman.enable {};
        nixd = mkIf cfg.servers.nixd.enable {};
        dockerls = mkIf cfg.servers.dockerls.enable {};
        bashls = mkIf cfg.servers.bashls.enable {};
        clangd = mkIf cfg.servers.clangd.enable {};
        csharp-ls = mkIf cfg.servers.csharp-ls.enable {};
        yamlls = mkIf cfg.servers.yamlls.enable {};
        lua-ls = mkIf cfg.servers.lua-ls.enable {
          settings.telemetry.enable = false;
          settings.diagnostics.globals = ["vim"];
        };
        tsserver = mkIf cfg.servers.tsserver.enable {};
        rust-analyzer = mkIf cfg.servers.rust-analyzer.enable {
          installRustc = true;
          installCargo = true;
          settings = {
            checkOnSave = true;
            check.command = "clippy";
          };
        };
      };
    };
  };
}
