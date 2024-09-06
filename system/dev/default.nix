{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.fenix.overlays.default];
  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    # Wayland-specific dependencies
    wayland # Wayland client library
    wayland-protocols # Wayland protocols (essential for building against Wayland)
    pkg-config # Helps to manage libraries during compilation

    # Aquamarine: Hyprland's new compositor library
    aquamarine # Aquamarine compositor library for Wayland

    # Language servers, other utilities and tools
    gcc
    lua-language-server
    nixd
    openssl
    php
    php84Packages.php-cs-fixer
    phpactor
    python312Packages.python-lsp-server
    bash-language-server
    nil
    nodePackages.vscode-langservers-extracted
    clang-tools
    marksman
    pyright
    nodePackages_latest.intelephense
    helix-gpt

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
