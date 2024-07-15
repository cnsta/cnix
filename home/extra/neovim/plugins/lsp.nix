{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
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

        # Language server
        servers = {
          # Average webdev LSPs
          cssls.enable = true; # CSS
          tailwindcss.enable = true; # TailwindCSS
          html.enable = true; # HTML
          astro.enable = true; # AstroJS
          phpactor.enable = true; # PHP
          svelte.enable = false; # Svelte
          vuels.enable = false; # Vue

          # Python
          pyright.enable = true;

          # Markdown
          marksman.enable = true;

          # Nix
          nil-ls.enable = true;

          # Docker
          dockerls.enable = true;

          # Bash
          bashls.enable = true;

          # C/C++
          clangd.enable = true;

          # C#
          csharp-ls.enable = true;

          # Lua
          lua-ls = {
            enable = true;
            settings.telemetry.enable = false;
            settings.diagnostics = {
              globals = ["vim"];
            };
          };
          tsserver = {
            enable = true; # TS/JS
          };
          # Rust
          rust-analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
            settings = {
              checkOnSave = true;
              check = {
                command = "clippy";
              };
            };
          };
        };
      };
    };
  };
}
