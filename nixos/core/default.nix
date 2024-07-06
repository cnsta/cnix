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
    ./fonts.nix
    ./hyprland.nix
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
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
      lxqt.lxqt-policykit

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
      ntfs3g
      udiskie
      gnome-disk-utility
      wlroots
      fzf
    ];
  };
}
