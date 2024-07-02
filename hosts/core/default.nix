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
    ./hyprland.nix
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
    systemPackages = with pkgs; [
      # Core
      git
      sbctl
      niv
      nix-output-monitor
      nvd

      # Util
      stow
      wget
      curl
      ripgrep
      python312Packages.oauth2
      python312Packages.httplib2
      killall
      tree-sitter
      lazygit
      tmux
      tmuxifier
      unzip
      p7zip
      unrar
      xdg-utils
      xdg-user-dirs
      udiskie
      wlroots
      fzf
    ];
  };
}
