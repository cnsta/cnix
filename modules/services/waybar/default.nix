{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cnix.services.waybar;

  waybar = lib.getExe pkgs.waybar;

  waybarAssets = pkgs.runCommand "waybar-config-assets" { } ''
    mkdir -p $out/assets
    cp ${./assets/button.svg}    $out/assets/button.svg
    cp ${./config/style.css}     $out/style.css
    cp ${./config/config.jsonc}  $out/config.jsonc
  '';
in
{
  options.cnix.services.waybar.enable = mkEnableOption "waybar";

  config = mkIf cfg.enable {
    systemd.user.services.waybar = {
      description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      documentation = [ "man:waybar(5)" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${waybar} -c ${waybarAssets}/config.jsonc -s ${waybarAssets}/style.css";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };
    };
  };
}
