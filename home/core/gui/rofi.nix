{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland-unwrapped;
    configPath = "$XDG_CONFIG_HOME/rofi/config.rasi";
    font = "Rec Mono Linear 11";
  };
}
