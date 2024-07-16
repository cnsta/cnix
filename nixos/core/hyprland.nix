{
  programs.hyprland = {
    enable = true;
    # xwayland.enable = true;
  };
  environment.variables = {
    # MOZ_ENABLE_WAYLAND = 1;
    NIXOS_OZONE_WL = "1";
    # AMD_VULKAN_ICD = "RADV";
    # SDL_VIDEODRIVER = "wayland";
    # QT_QPA_PLATFORM = "wayland";
    # XDG_SESSION_TYPE = "wayland";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}
