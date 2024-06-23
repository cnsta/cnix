# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    ./neovim
    ./git
    ./gtk
    ./shell
    ./firefox
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
    alacritty
    wl-clipboard
    dunst
    keepassxc
    ranger
    webcord
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gnome.file-roller
    gvfs
    swaybg
    wireguard-tools
    wpa_supplicant
    ntfs3g
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
    mullvad-vpn
    thefuck
    calcurse
  ];

  # Hyprland & accessories
  # wayland.windowManager.hyprland.enable = true;
  # programs.waybar.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    extraConfig = ''
      ${builtins.readFile ./hypr/hyprland.conf}
    '';
    systemd.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    NIXOS_OZONE_WL = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
