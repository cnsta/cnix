{ pkgs, inputs, ... }:
with pkgs;
let

  tools = [
    fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
    fzf
    git
    sqlite
    tree-sitter
  ];

  c = [
    clang
    clang-tools
    cmake
    gcc
    gnumake
  ];

  gamedev = [
    # parser, linter and formatter for GDScript
    gdtoolkit_3
    gdtoolkit_4
  ];

  golang = [
    delve # debugger
    go
    gofumpt
    goimports-reviser
    golines
    gopls
    gotools
  ];

  lua = [
    lua-language-server
    stylua
  ];

  markup = [
    cbfmt # format codeblocks
    codespell
    markdownlint-cli
    mdformat
    typst-lsp
  ];

  nix = [
    alejandra
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
    statix
  ];

  python = [
    black
    isort
    python311Packages.jedi-language-server
    ruff
    ruff-lsp
  ];

  rust = [
    cargo
    rustfmt
    rust-analyzer
  ];

  shell = [
    nodePackages.bash-language-server
    shellcheck
    shfmt
  ];

  web = [
    deno
    nodePackages.sql-formatter
    nodePackages.typescript-language-server
    nodejs
    prettierd # multi-language formatters
    vscode-langservers-extracted
    yarn
  ];

  extraPackages =
    tools ++ c ++ gamedev ++ golang ++ lua ++ markup ++ nix ++ python ++ rust ++ shell ++ web;
in

{
  # for quick development
  home.packages = rust;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    plugins = with pkgs.vimPlugins; [ telescope-cheat-nvim ];
    inherit extraPackages;
  };
}
