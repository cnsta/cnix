{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.devtools.neovim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./autocmd.nix
    ./completion.nix
    ./keymap.nix
    ./options.nix
    ./todo.nix
  ];

  options = {
    modules.devtools.neovim.enable = mkEnableOption "Enable Neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [pkgs.vimPlugins.gruvbox-material];
      colorscheme = "gruvbox-material";
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;
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
  };
}
