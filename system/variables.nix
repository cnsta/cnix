{
  environment.sessionVariables = {
    NIX_AUTO_RUN = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland,x11,windows";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELECTRON_FORCE_DARK_MODE = "1";
    ELECTRON_ENABLE_DARK_MODE = "1";
    ELECTRON_USE_SYSTEM_THEME = "1";
    ELECTRON_DISABLE_DEFAULT_MENU_BAR = "1";
  };
}
