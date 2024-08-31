{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.devtools.neovim;
in {
  options = {
    modules.devtools.neovim.enable = mkEnableOption "Enables neovim";
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
        gruvbox-material-nvim
        nvim-web-devicons
        comment-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        cmp-spell
        cmp-treesitter
        cmp-vsnip
        friendly-snippets
        gitsigns-nvim
        lightline-vim
        lspkind-nvim
        neogit
        null-ls-nvim
        nvim-autopairs
        nvim-cmp
        nvim-colorizer-lua
        nvim-lspconfig
        nvim-tree-lua
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        plenary-nvim
        rainbow-delimiters-nvim
        telescope-fzy-native-nvim
        telescope-nvim
        vim-floaterm
        vim-sneak
        vim-vsnip
        which-key-nvim
        copilot-lua
        copilot-cmp
        statix
        phpactor
      ];

      extraPackages = with pkgs; [nixd gcc ripgrep fd deadnix lua-language-server yaml-language-server bash-language-server];

      extraConfig = let
        luaRequire = module:
          builtins.readFile (builtins.toString
            ./config
            + "/${module}.lua");
        luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
          "init"
          "lspconfig"
          "nvim-cmp"
          "theming"
          "treesitter"
          "treesitter-textobjects"
          "utils"
          "which-key"
        ]);
      in ''
        lua << 
        ${luaConfig}
        
      '';
    };
  };
}
