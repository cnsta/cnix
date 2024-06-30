# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./adb.nix
    ./zsh.nix
    ./cnix-pkgs.nix
    ./fonts.nix
    ./hypr
  ];
  home-manager = {
    # useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  programs.dconf.enable = true;

  console.useXkbConfig = true;

  environment = {
    localBinInPath = true;
    systemPackages = [
      # Dev
      pkgs.git

      # Util
      pkgs.stow
      pkgs.wget
      pkgs.curl
      pkgs.ripgrep
      pkgs.python312Packages.oauth2
      pkgs.python312Packages.httplib2
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
      pkgs.udiskie
      pkgs.wlroots
      pkgs.fzf
    ];
  };
}
