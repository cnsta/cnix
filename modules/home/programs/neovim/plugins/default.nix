{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-illuminate
  ];
  imports = [
    ./alpha.nix
    ./bufferline.nix
    ./copilot.nix
    ./fidget.nix
    ./gitsigns.nix
    ./treesitter.nix
    ./conform.nix
    ./gx.nix
    ./bqf.nix
    ./colorizer.nix
    ./web-devicons.nix
    ./oil.nix
    ./lualine.nix
    ./range-highlight.nix
    ./fugitive.nix
    ./which-key.nix
    ./autopairs.nix
  ];
}
