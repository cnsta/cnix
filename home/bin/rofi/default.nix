{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland-unwrapped;
    configPath = "home/cnst/.config/rofi/config.rasi";
    font = "Rec Mono Linear 11";
  };
}
