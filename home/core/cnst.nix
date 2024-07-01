{
  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    TERM = "kitty";
    AMD_VULKAN_ICD = "RADV";
    NIXOS_OZONE_WL = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
  imports = [
    ./git
    ./gui
    ./shell/cnst.nix
    ./appearance
  ];
}
