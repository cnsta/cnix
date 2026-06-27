{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.cnix.programs.pkgs;
  hardware = with pkgs; [
    pciutils
    ddcutil
    lm_sensors
    lshw
    dmidecode
    parted
    ntfs3g
  ];
  network = with pkgs; [
    wireguard-tools
    traceroute
    dig
    cloudflared
  ];
  archives = with pkgs; [
    unzip
    zip
    gnutar
    gnused
    p7zip
    unrar
  ];
  textTools = with pkgs; [
    jq
    ripgrep
    fd
    file
    tree
    progress
    vim
  ];
  nixTooling = with pkgs; [
    nil
    nix-tree
  ];
  security = with pkgs; [
    libargon2
    openssl
    git-crypt
  ];
  monitoring = with pkgs; [htop];
  miscCommon = with pkgs; [
    stow
    socat
    libnotify
    libqalculate
    exiftool
    app2unit
    ocl-icd
  ];
  minimal = with pkgs; [
    htop
    jq
    ripgrep
    fd
    file
    tree
    unzip
    gnutar
    gnused
    openssl
    dig
    traceroute
    vim
  ];
  common =
    hardware ++ network ++ archives ++ textTools ++ nixTooling ++ security ++ monitoring ++ miscCommon;
  # gui
  guiSystem = with pkgs; [
    resources
    gnome-disk-utility
    gparted
    networkmanagerapplet
    networkmanager_dmenu
    inotify-tools
    brightnessctl
    gnome-calculator
    overskride
  ];
  guiCapture = with pkgs; [
    swappy
    wayfreeze
    slurp
    grimblast
    wf-recorder
    wl-screenrec
    wl-clipboard
    hyprpicker
    cava
    sniffnet
  ];
  guiImage = with pkgs; [
    imagemagick
    feh
    loupe
    tesseract
  ];
  guiTheming = with pkgs; [
    inputs.ashell.packages.${pkgs.stdenv.hostPlatform.system}.default
    kdePackages.qt6ct
    libsForQt5.qt5ct
    nwg-look
    adwaita-icon-theme
    material-icons
    material-symbols
  ];
  guiWayland = with pkgs; [
    wayland-utils
    qt5.qtwayland
    qt6.qtwayland
  ];
  guiMedia = with pkgs; [
    feishin
    nautilus
  ];
  gui = guiSystem ++ guiCapture ++ guiImage ++ guiTheming ++ guiWayland ++ guiMedia;

  # desktop/laptop/server
  desktop = with pkgs; [
    geekbench
    obs-studio
    protontricks
  ];
  laptop = [];
  server = with pkgs; [
    nvtopPackages.intel
    zfstools
  ];
  # dev
  devLsps = with pkgs; [
    marksman
  ];
  devBuild = with pkgs; [
    gcc
    pkg-config
  ];
  devRuntimes = with pkgs; [
    nodejs
  ];
  devDbs = with pkgs; [sqlite];
  devFormatters = with pkgs; [
    fixjson
    sql-formatter
    prettierd
    black
    nufmt
    nu-lint
  ];
  devOther = with pkgs; [
    nfs-utils
  ];
  devCommon = devLsps ++ devBuild ++ devRuntimes ++ devDbs ++ devFormatters ++ devOther;
  devRust = [];
  devPhp = with pkgs; [
    php
  ];
  devPython = with pkgs; [
    pyright
    python314Packages.python-lsp-server
    python3
    python3Packages.pyusb
    python3Packages.pygobject3
  ];
in {
  options.cnix.programs.pkgs = {
    minimal.enable = mkEnableOption "bare-essential packages";
    common.enable = mkEnableOption "core packages";
    desktop.enable = mkEnableOption "desktop-specific packages";
    gui.enable = mkEnableOption "gui-specific packages";
    laptop.enable = mkEnableOption "laptop-specific packages";
    server.enable = mkEnableOption "server-specific packages";
    dev = {
      common.enable = mkEnableOption "generic development packages";
      rust.enable = mkEnableOption "rust packages";
      php.enable = mkEnableOption "php packages";
      python.enable = mkEnableOption "python packages";
    };
  };
  config.environment.systemPackages = mkMerge [
    (mkIf cfg.minimal.enable minimal)
    (mkIf cfg.common.enable common)
    (mkIf cfg.gui.enable gui)
    (mkIf cfg.desktop.enable desktop)
    (mkIf cfg.laptop.enable laptop)
    (mkIf cfg.server.enable server)
    (mkIf cfg.dev.common.enable devCommon)
    (mkIf cfg.dev.rust.enable devRust)
    (mkIf cfg.dev.php.enable devPhp)
    (mkIf cfg.dev.python.enable devPython)
  ];
}
