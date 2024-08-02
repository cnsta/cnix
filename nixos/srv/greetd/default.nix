{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      # AUTOLOGIN
      # initial_session = {
      #   command = "${pkgs.hyprland}/bin/Hyprland";
      #   user = "adam";
      # };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session --asterisks";
        user = "adam";
      };
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
}
