{ pkgs, ... }:
{
  environment = {
    systemPackages = [
      # Dev
      pkgs.git
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

      # Util
      pkgs.stow
      pkgs.gnumake
      pkgs.wget
      pkgs.curl
      pkgs.ripgrep
      pkgs.python312Packages.oauth2
      pkgs.python312Packages.httplib2
      pkgs.python312Packages.pip
      pkgs.killall
      pkgs.tree-sitter
      pkgs.lazygit
      pkgs.tmux
      pkgs.tmuxifier
      pkgs.unzip
      pkgs.p7zip
      pkgs.unrar
      pkgs.xdg-utils
      pkgs.xdg-user-dirs
    ];
  };
}
