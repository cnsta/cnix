{ osConfig, clib, ... }:
let
  host = osConfig.networking.hostName;
  en = clib.mkEn host;
  when = clib.mkWhen host;
  none = clib.mkNone host;
in
{
  home = {
    programs = {
      aerc = none;
      alacritty = en "kbt";
      bash = none;
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
      floorp = none;
      foot = en "kbt";
      fuzzel = en "kbt";
      ghostty = none;
      git = en "kbt";
      jujutsu = none;
      kitty = none;
      librewolf = en "kbt";
      mpv = en "kbt";
      neovim = none;
      nushell = none;
      nvf = en "t";
      nwg-bar = en "kbt";
      pkgs = {
        common = en "kbt";
        gui = en "kbt";
        desktop = en "kt";
        laptop = none;
        dev = none;
      };
      rofi = none;
      ssh = en "kbt";
      thunderbird = en "kbt";
      vscode = en "t";
      waybar = en "bt";
      wezterm = none;
      yazi = en "kbt";
      zathura = en "kbt";
      zed-editor = none;
      zellij = none;
      zen = none;
      zsh = none;
    };

    services = {
      blueman-applet = none;
      copyq = none;
      dconf = when "kbt" { settings.color-scheme = "prefer-dark"; };
      dunst = none;
      gpg = en "kbt";
      gtk = en "kbt";
      jellyfin-mpv-shim = none;
      mako = none;
      quickshell = en "k";
      swaync = en "bt";
      syncthing = none;
      tailray = en "kbt";
      udiskie = en "kbt";
      xdg = en "kbt";
    };
  };
}
