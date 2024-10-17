{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Language servers, other utilities and tools
    gcc
    rust-analyzer
    lua-language-server
    nixd
    php
    # php84Packages.php-cs-fixer
    phpactor
    python312Packages.python-lsp-server
    bash-language-server
    nil
    nodePackages.vscode-langservers-extracted
    clang-tools
    marksman
    pyright
    nodePackages_latest.intelephense

    # Formatters
    alejandra
    stylua
    nodePackages_latest.fixjson
    nodePackages_latest.sql-formatter
    prettierd
    shfmt
    luaformatter
    black
  ];
}
