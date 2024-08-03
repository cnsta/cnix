{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      # AUTOLOGIN
      # initial_session = {
      #   command = "${pkgs.hyprland}/bin/Hyprland";
      #   user = "cnst"; # <- select which user to auto-login
      # };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session --asterisks";
        user = "greeter";
      };
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
}
