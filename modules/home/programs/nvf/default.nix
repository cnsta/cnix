# Yanked from @Soliprem to try it out
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.nvf;
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  options = {
    home.programs.nvf.enable = mkEnableOption "Enables nvf (neovim)";
  };
  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      enableManpages = true;
      settings = {
        vim = {
          repl = {
            conjure.enable = true;
          };
          spellcheck = {
            enable = true;
            languages = [
              "en"
            ];
          };
          clipboard = {
            enable = true;
            registers = "unnamedplus";
            providers.wl-copy.enable = true;
          };
          options = {
            shiftwidth = 2;
            conceallevel = 1;
            scrolloff = 1;
          };
          preventJunkFiles = true;
          searchCase = "smart";
          viAlias = true;
          vimAlias = true;
          undoFile = {
            enable = true;
          };
          debugMode = {
            enable = false;
            level = 16;
            logFile = "/tmp/nvim.log";
          };
          lsp = {
            formatOnSave = true;
            lspkind.enable = false;
            lightbulb.enable = false;
            lspsaga.enable = false;
            otter-nvim = {
              enable = true;
              setupOpts.buffers.write_to_disk = true;
            };
            trouble.enable = true;
          };

          debugger = {
            nvim-dap = {
              enable = true;
              ui.enable = true;
            };
          };

          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            nim.enable = false;
            java.enable = false;
            svelte.enable = false;
            vala.enable = false;
            dart.enable = false;
            elixir.enable = false;
            haskell.enable = true;
            nix.enable = true;
            markdown.enable = true;
            html.enable = true;
            css.enable = true;
            r = {
              enable = true;
              format.type = [ "styler" ];
            };
            sql.enable = true;
            typescript = {
              enable = true;
              extraDiagnostics.enable = false;
            };
            go.enable = true;
            zig.enable = true;
            ocaml.enable = true;
            nu.enable = true;
            python = {
              enable = true;
              lsp.servers = [ "pyright" ];
            };
            lua.enable = true;
            bash.enable = true;
            typst.enable = true;
            julia.enable = true;
            clang = {
              enable = true;
              lsp.servers = [ "clangd" ];
            };

            rust = {
              enable = true;
              extensions.crates-nvim.enable = true;
            };
          };

          visuals = {
            nvim-web-devicons.enable = true;
            cellular-automaton.enable = true;
            fidget-nvim.enable = true;
            highlight-undo.enable = true;

            indent-blankline = {
              enable = true;
            };

            nvim-cursorline = {
              enable = true;
              setupOpts = {
                lineTimeout = 0;
              };
            };
          };

          statusline = {
            lualine = {
              enable = true;
              setupOpts = {
                options.theme = "gruvbox-material";
              };
            };
          };

          theme.enable = false;

          extraPlugins = with pkgs.vimPlugins; {
            gruvbox-material = {
              package = gruvbox-material;
              setup = "vim.cmd.colorscheme 'gruvbox-material'";
            };
          };

          autopairs.nvim-autopairs.enable = true;

          autocomplete.blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
            setupOpts = {
              signature.enabled = true;
            };
          };
          snippets.luasnip.enable = true;

          filetree = {
            nvimTree = {
              enable = false;
            };
          };

          tabline = {
            nvimBufferline.enable = false;
          };

          treesitter = {
            context.enable = true;
            grammars = [
              pkgs.vimPlugins.nvim-treesitter-parsers.nu
            ];
          };

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          telescope.enable = true;

          git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions.enable = false; # throws an annoying debug message
          };

          minimap = {
            minimap-vim.enable = false;
            codewindow.enable = false; # lighter, faster, and uses lua for configuration
          };

          dashboard = {
            dashboard-nvim.enable = false;
            alpha.enable = true;
          };

          notify = {
            nvim-notify.enable = true;
          };

          projects = {
            project-nvim.enable = false;
          };

          utility = {
            undotree.enable = true;
            oil-nvim.enable = true;
            ccc.enable = false;
            vim-wakatime.enable = true;
            icon-picker.enable = true;
            surround.enable = true;
            diffview-nvim.enable = true;
            motion = {
              hop.enable = false;
              leap = {
                enable = true;
                mappings = {
                  leapForwardTo = "s";
                  leapBackwardTo = "S";
                };
              };
              precognition.enable = false;
            };

            images = {
              image-nvim.enable = false;
              img-clip.enable = true;
            };
          };

          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };

          ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            modes-nvim.enable = false; # the theme looks terrible with catppuccin
            illuminate.enable = true;
            # fastaction.enable = true;
            breadcrumbs = {
              enable = true;
              navbuddy.enable = true;
            };
            smartcolumn = {
              enable = true;
              setupOpts.custom_colorcolumn = {
                # this is a freeform module, it's `buftype = int;` for configuring column position
                nix = "110";
                ruby = "120";
                java = "130";
                # go = ["90 130"];
              };
            };
          };

          assistant = {
            chatgpt.enable = false;
            copilot = {
              enable = false;
              cmp.enable = false;
            };
          };

          session = {
            nvim-session-manager.enable = false;
          };

          gestures = {
            gesture-nvim.enable = false;
          };

          comments = {
            comment-nvim.enable = true;
          };

          presence = {
            neocord.enable = false;
          };
          lazy.plugins = with pkgs.vimPlugins; {
            ${lazygit-nvim.pname} = {
              lazy = true;
              cmd = [
                "LazyGit"
                "LazyGitConfig"
                "LazyGitCurrentFile"
                "LazyGitFilter"
                "LazyGitFilterCurrentFile"
              ];
              package = lazygit-nvim;
              setupOpts = {
                open_cmd = "zen %s";
              };
              keys = [
                {
                  key = "<leader>lg";
                  action = "<cmd>LazyGit<cr>";
                  mode = "n";
                }
              ];
            };
          };
          keymaps = [
            {
              key = "<esc>";
              mode = "n";
              action = ":noh<CR>";
              silent = true;
              desc = "removes search highlight when pressing esc";
            }
            {
              key = "<leader><leader>";
              mode = "n";
              action = ":Telescope find_files<CR>";
              silent = true;
              desc = "Look for Files";
            }
            {
              key = "-";
              action = ":Oil<CR>";
              mode = "n";
              silent = true;
              desc = "enable Oil";
            }
            {
              key = "<F5>";
              action = ":UndotreeToggle<CR>";
              mode = "n";
              silent = true;
              desc = "Toggle Undotree";
            }
          ];
        };
      };
    };
  };
}
