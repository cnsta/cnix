{
  security = {
    rtkit.enable = true;
    pam.services.hyprlock.text = "auth include login";
  };
}
