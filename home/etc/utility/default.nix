{pkgs, ...}: {
  programs = {
    ssh = {
      enable = true;
    };
    # image viewer
    feh = {
      enable = true;
    };
    # system information
    fastfetch = {
      enable = true;
    };
    # a monitor of resources
    btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_material_dark";
      };
    };
  };
  home.packages = with pkgs; [
    file-roller # archiver
    gnome-calculator
    nwg-look # GTK settings
    hyprpicker # Color picker
    pavucontrol # GUI sound control
    pamixer # TUI sound control
    keepassxc
    calcurse # calendar
    grimblast # screenshot
    slurp # select region for screenshot
    qbittorrent
    networkmanagerapplet # tray icon for NetworkManager
    usbimager # write bootable usb images!
    chatgpt-cli
    exiftool
    libnotify
    filezilla
  ];
}
