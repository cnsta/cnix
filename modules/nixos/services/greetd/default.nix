{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.nixos.services.greetd;
in
{
  options = {
    nixos.services.greetd = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enables the greetd service.";
      };
      user = mkOption {
        type = types.str;
        default = "cnst";
        description = "The username to auto-login when autologin is enabled.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.greetd =
      let
        session = {
          command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
          user = cfg.user;
        };
      in
      {
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session = session;
          initial_session = session;
        };
      };
  };
}
