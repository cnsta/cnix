{pkgs, ...}: {
  # greetd display manager
  services.greetd = let
    session = {
      command = "${pkgs.hyprland}/bin/Hyprland";
      user = "cnst";
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
    };
  };

  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
