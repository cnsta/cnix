{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.mako;
in {
  options = {
    home.services.mako.enable = mkEnableOption "Enables mako";
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      iconPath = "$HOME/.nix-profile/share/icons/Gruvbox-Plus-Dark";
      font = "Input Sans Narrow Regular 12";
      padding = "20";
      margin = "10";
      anchor = "top-right";
      width = 400;
      height = 150;
      borderSize = 2;
      defaultTimeout = 12000;
      backgroundColor = "#3c3836dd";
      borderColor = "#689d6add";
      textColor = "#d5c4a1dd";
      layer = "overlay";
      extraConfig = let
        play = sound: "mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/${sound}.oga";
      in ''
        max-history=50
        max-visible=4
        outer-margin=25
        icon-location=right
        max-icon-size=48
        [urgency=high]
        border-color=#7DAEA3dd
        [urgency=critical]
        border-color=#f95f32dd
        on-notify=exec ${play "message"}
        [app-name=yubikey-touch-detector]
        on-notify=exec ${play "service-login"}
        [app-name=command_complete summary~="✘.*"]
        on-notify=exec ${play "dialog-warning"}
        [app-name=command_complete summary~="✓.*"]
        on-notify=exec ${play "bell"}
        [mode=do-not-disturb]
        invisible=1
      '';
    };
  };
}
