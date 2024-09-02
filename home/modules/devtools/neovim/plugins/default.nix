{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-illuminate
  ];
  imports = [
    ./alpha-nvim.nix
    ./bufferline-nvim.nix
    ./comment-nvim.nix
    ./copilot-lua.nix
    ./fidget-nvim.nix
    ./gitsigns-nvim.nix
    ./treesitter.nix
    ./conform-nvim.nix
    ./gx-nvim.nix
    ./nvim-bqf.nix
    ./nvim-colorizer-lua.nix
    ./nvim-web-devicons.nix
    ./oil.nix
    ./lualine.nix
    ./range-highlight-nvim.nix
    ./vim-fugitive.nix
    ./which-key.nix
  ];
}
