{ userModules, ... }: {
  imports = [
    "${userModules}/devtools/neovim/plugins/ai.nix"
    "${userModules}/devtools/neovim/plugins/barbar.nix"
    "${userModules}/devtools/neovim/plugins/comment.nix"
    "${userModules}/devtools/neovim/plugins/conform.nix"
    "${userModules}/devtools/neovim/plugins/efm.nix"
    "${userModules}/devtools/neovim/plugins/floaterm.nix"
    "${userModules}/devtools/neovim/plugins/harpoon.nix"
    "${userModules}/devtools/neovim/plugins/lsp.nix"
    "${userModules}/devtools/neovim/plugins/lualine.nix"
    "${userModules}/devtools/neovim/plugins/markdown-preview.nix"
    "${userModules}/devtools/neovim/plugins/neo-tree.nix"
    "${userModules}/devtools/neovim/plugins/nonels.nix"
    "${userModules}/devtools/neovim/plugins/startify.nix"
    "${userModules}/devtools/neovim/plugins/tagbar.nix"
    "${userModules}/devtools/neovim/plugins/telescope.nix"
    "${userModules}/devtools/neovim/plugins/treesitter.nix"
    "${userModules}/devtools/neovim/plugins/vimtex.nix"
    "${userModules}/devtools/neovim/plugins/yanky.nix"
  ];
}
