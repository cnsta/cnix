{pkgs, ...}: {
  services = {
    dbus.packages = with pkgs; [
      gcr
      gnome.gnome-settings-daemon
    ];
    udisks2.enable = true;
    gvfs.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    greetd = {
      enable = true;
      settings = {
        #        initial_session = {
        #          command = "${pkgs.hyprland}/bin/Hyprland";
        #          user = "cnst";
        #        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session";
          user = "greeter";
        };
      };
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      xkb = {
        extraLayouts.hhkbse = {
          description = "HHKBse by cnst";
          languages = ["se"];
          symbolsFile = /home/cnst/.nix-config/nixos/hosts/cnix/xkb/symbols/hhkbse;
        };
        layout = "hhkbse";
        # dir = "/home/cnst/.nix-config/nixos/xkb";
        variant = "";
        options = "lv3:rwin_switch";
      };
    };
  };
}
