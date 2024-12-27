{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.waybar;
in {
  options = {
    home.programs.waybar.enable = mkEnableOption "Enables waybar";
  };
  config = mkIf cfg.enable {
    systemd.user.services.waybar = {
      Unit.StartLimitBurst = 30;
    };
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      systemd.enable = true;
      # style = ./style.css;

      settings = [
        {
          height = 25;

          modules-left = [
            "group/system"
          ];

          modules-center = [
            "hyprland/workspaces"
          ];

          modules-right = [
            "custom/progress"
            "custom/systemd"
            # "custom/mail"
            "group/tray"
            "pulseaudio"
            "backlight"
            "battery"
            "clock"
            "custom/mako"
          ];

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              "default" = "";
              "active" = "";
              "empty" = "";
              "persistent" = "";
            };
            disable-scroll = true;
            rotate = 0;
            all-outputs = true;
            active-only = false;
            on-click = "activate";
            persistent-workspaces = {
              "*" = 3;
            };
          };

          "group/tray" = {
            orientation = "inherit";
            drawer = {
              transition-left-to-right = false;
              transistion-duration = 250;
              click-to-reveal = true;
            };
            modules = [
              "custom/trayicon"
              "tray"
            ];
          };

          "group/system" = {
            orientation = "inherit";
            drawer = {
              transistion-left-to-right = true;
              transition-duration = 250;
              click-to-reveal = true;
            };
            modules = [
              "custom/logo"
              "cpu"
              "memory"
              "disk"
              "network"
            ];
          };

          "custom/trayicon" = {
            format = "󰅁";
            tooltip = false;
          };

          "custom/logo" = {
            format = "   ";
            tooltip = false;
          };

          "custom/mako" = {
            exec = "mako.sh";
            on-click = "mako-toggle.sh";
            restart-interval = 1;
            tooltip = false;
          };

          "custom/progress" = {
            exec = "waybar-progress.sh";
            return-type = "json";
            interval = 1;
          };

          "custom/systemd" = {
            exec = "waybar-systemd.sh";
            return-type = "json";
            interval = 10;
          };

          # "custom/mail" = {
          #   format-icons = {
          #     icon = "<span foreground='#928374'> </span>";
          #   };
          #   format = "{icon}{}";
          #   exec = "${app}/bin/waybar-mail";
          #   return-type = "json";
          # };

          # "custom/recording" = {
          #   exec = "${app}/bin/waybar-recording";
          #   return-type = "json";
          #   signal = 3;
          #   interval = "once";
          # };

          tray = {
            icon-size = 12;
            rotate = 0;
            spacing = 5;
          };

          clock = {
            format = "<span foreground='#928374'></span> {:%a, %d %b  <span foreground='#928374'></span> %H:%M}";
            rotate = 0;
            on-click = "calcurse-toggle.sh";
            on-click-right = "calsync.sh";
            tooltip = false;
          };

          cpu = {
            format = "<span foreground='#928374'></span> {usage}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          disk = {
            format = "<span foreground='#928374'></span> {percentage_free}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          memory = {
            format = "<span foreground='#928374'></span> {}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          backlight = {
            format = "<span foreground='#928374'>{icon}</span> {percent}%";
            format-icons = [""];
            tooltip = false;
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "<span foreground='#928374'>{icon}</span> {capacity}%";
            format-charging = "<span foreground='#928374'></span> {capacity}%";
            format-icons = ["" "" "" "" ""];
          };

          network = {
            interval = 2;
            format-wifi = "<span foreground='#928374'></span> {essid}";
            format-ethernet = "<span foreground='#928374'></span> {ifname}";
            format-linked = "<span foreground='#928374'></span> {ifname}";
            format-disconnected = " <span foreground='#928374'></span> ";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}\n {bandwidthDownBits}\n {bandwidthUpBits}";
          };

          pulseaudio = {
            format = "<span foreground='#928374'>{icon}</span> {volume}%  {format_source}";
            on-scroll-up = "volume-control.sh --inc";
            on-scroll-down = "volume-control.sh --dec";
            format-bluetooth = "<span foreground='#928374'>{icon}</span> {volume}%  {format_source}";
            format-bluetooth-muted = "<span foreground='#928374'> {icon}</span>  {format_source}";
            format-muted = "<span foreground='#928374'></span>  {format_source}";
            format-source = "<span foreground='#928374'></span> {volume}%";
            format-source-muted = "<span foreground='#928374'></span>";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = lib.getExe pkgs.pavucontrol;
            on-click-middle = lib.getExe pkgs.helvum;
          };
        }
      ];
    };
  };
}
