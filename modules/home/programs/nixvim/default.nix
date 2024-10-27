{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.nixvim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./autocmd.nix
    ./keymap.nix
    ./options.nix
    ./todo.nix
  ];

  options = {
    home.programs.nixvim.enable = mkEnableOption "Enable nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [gruvbox-material-nvim nvim-web-devicons];
      colorscheme = "gruvbox-material";
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;
      plugins = {
        gitsigns.enable = true;
        statuscol.enable = true;
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
