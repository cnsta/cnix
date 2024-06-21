# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "cnst";
    homeDirectory = "/home/cnst";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Desktop
    firefox
    alacritty
    wl-clipboard
    dunst
    keepassxc
    ranger
    webcord-vencord
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xarchiver
    gvfs
    swaybg
    wireguard-tools
    solaar
    wpa_supplicant
    ntfs3g
    xdg-utils
    kdePackages.polkit-kde-agent-1
    networkmanagerapplet
    blueman
    htop
    btop
    tofi
    pamixer
    virt-manager
    qbittorrent
    fastfetch
    waybar
    nwg-look
    lxappearance
    orchis-theme
    gruvbox-plus-icons
    gruvbox-gtk-theme
    mullvad-vpn
    thefuck
  ];

  # Hyprland & accessories
  # wayland.windowManager.hyprland.enable = true;
  # programs.waybar.enable = true;

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;
    extraConfig = ''
      ${builtins.readFile ./hypr/hyprland.conf}
    '';
    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    GTK_THEME = "Orchis-Grey-Dark";
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "cnst";
      userEmail = "cnst@cana.st";
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "thefuck"];
        theme = "robbyrussell";
      };
    };
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
