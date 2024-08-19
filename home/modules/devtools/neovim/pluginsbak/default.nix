{
  pkgs,
  config,
  lib,
  concatLists,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.modules.devtools.neovim;
in {
  imports = concatLists [
    mkIf
    (cfg.barbar.enable or true)
    [./barbar.nix]
    mkIf
    (cfg.chatgpt.enable or true)
    [./chatgpt.nix]
    mkIf
    (cfg.comment.enable or true)
    [./comment.nix]
    mkIf
    (cfg.conform.enable or true)
    [./conform.nix]
    mkIf
    (cfg.efm.enable or true)
    [./efm.nix]
    mkIf
    (cfg.lsp.enable or true)
    [./lsp.nix]
    mkIf
    (cfg.lualine.enable or true)
    [./lualine.nix]
    mkIf
    (cfg.markdown-preview.enable or true)
    [./markdown-preview.nix]
    mkIf
    (cfg.neo-tree.enable or true)
    [./neo-tree.nix]
    mkIf
    (cfg.nonels.enable or true)
    [./nonels.nix]
    mkIf
    (cfg.startify.enable or true)
    [./startify.nix]
    mkIf
    (cfg.tagbar.enable or true)
    [./tagbar.nix]
    mkIf
    (cfg.telescope.enable or true)
    [./telescope.nix]
    mkIf
    (cfg.treesitter.enable or true)
    [./treesitter.nix]
  ];

  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.gruvbox-material];
    colorscheme = "gruvbox-material";

    plugins = {
      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
        };
      };

      nvim-autopairs.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };

      oil.enable = true;

      trim = {
        enable = true;
        settings = {
          highlight = false;
          ft_blocklist = [
            "checkhealth"
            "floaterm"
            "lspinfo"
            "neo-tree"
            "TelescopePrompt"
          ];
        };
      };
    };
  };
}
