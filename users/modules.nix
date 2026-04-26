{ osConfig, clib, ... }:
let
  host = osConfig.networking.hostName;
  en = clib.mkEn host;
  when = clib.mkWhen host;
in
{
  home.programs = {
    aerc = en "";
    alacritty = en "kbt";
    bash = en "";
    chromium = en "kt";
    direnv = en "kbt";
    discord = when "kbt" {
      enable = true;
      variant = "vesktop";
    };
    element-desktop = en "k";
    eza = en "kb";
    firefox = en "k";
    fish = en "kbt";
    floorp = en "";
    foot = en "kbt";
    fuzzel = en "kbt";
    ghostty = en "";
    git = en "kbt";
    jujutsu = en "";
    kitty = en "";
    librewolf = en "kbt";
    mpv = en "kbt";
    neovim = en "";
    nushell = en "";
    nvf = en "t";
    nwg-bar = en "kbt";
    pkgs = when "k" {
      enable = true;
      gui.enable = true;
      desktop.enable = true;
    };
    rofi = en "";
    ssh = en "kbt";
    thunderbird = en "kbt";
    vscode = en "t";
    waybar = en "bt";
    wezterm = en "";
    yazi = en "kbt";
    zathura = en "kbt";
    zed-editor = en "";
    zellij = en "";
    zen = en "";
    zsh = en "";
  };

  home.services = {
    blueman-applet = en "";
    copyq = en "";
    dconf = when "kbt" { settings.color-scheme = "prefer-dark"; };
    dunst = en "";
    gpg = en "kbt";
    gtk = en "kbt";
    jellyfin-mpv-shim = en "";
    mako = en "";
    quickshell = en "k";
    swaync = en "bt";
    syncthing = en "";
    tailray = en "kbt";
    udiskie = en "kbt";
    xdg = en "kbt";
  };
}
