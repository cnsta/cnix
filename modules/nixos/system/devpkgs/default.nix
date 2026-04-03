{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.nixos.system.devpkgs;
in
{
  options = {
    nixos.system.devpkgs = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable various packages for development";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Language servers, utilities, and tools
      gcc
      rust-analyzer
      lua-language-server
      nixd
      nil
      php
      # php84Packages.php-cs-fixer
      # phpactor
      # python312Packages.python-lsp-server
      bash-language-server
      clang-tools
      marksman
      pyright

      # Formatters
      alejandra
      stylua
      prettierd
      shfmt
      black
    ];
  };
}
