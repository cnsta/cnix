{ pkgs, ... }:
{
  environment = {
    systemPackages = [
      # Dev
      pkgs.pyright
      pkgs.python3
      pkgs.gcc
      pkgs.go
      pkgs.nodePackages_latest.npm
      pkgs.nodePackages_latest.nodejs
      pkgs.nodePackages.prettier
      pkgs.nodePackages.prettier-plugin-toml
      pkgs.lua-language-server
      pkgs.stylua
      pkgs.prettierd
      pkgs.cargo
      pkgs.hyprlang
      pkgs.nixd
      pkgs.nil
      pkgs.black
      pkgs.python312Packages.jedi-language-server
      pkgs.isort
      pkgs.bacon
      pkgs.clang
      pkgs.clang-tools
      pkgs.alejandra
      pkgs.nixpkgs-fmt

      # Util
      pkgs.python312Packages.pip
      pkgs.tmux
      pkgs.tmuxifier
    ];
  };
}
