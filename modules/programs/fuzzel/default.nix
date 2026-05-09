{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.fuzzel;
  acct = config.cnix.settings.accounts;

  settings = {
    main = {
      layer = "overlay";
      font = "Input Sans Narrow Light:size=12";
      launch-prefix = "uwsm-app --";
      lines = 8;
    };
    colors = {
      background = "282828ff";
      text = "928374ff";
      prompt = "ebdbb2ff";
      placeholder = "928374ff";
      input = "ebdbb2ff";
      match = "ebdbb2ff";
      selection = "32302fff";
      selection-text = "ebdbb2ff";
      selection-match = "ebdbb2ff";
      counter = "4c7a5dff";
      border = "4c7a5dff";
    };
    border = {
      width = 3;
      radius = 0;
    };
  };
in
{
  options.cnix.programs.fuzzel.enable = mkEnableOption "fuzzel";

  config = mkIf cfg.enable {
    hjem.users = genAttrs acct.defaultUsers (_: {
      packages = [ pkgs.fuzzel ];
      xdg.config.files."fuzzel/fuzzel.ini" = {
        generator = lib.generators.toINI { };
        value = settings;
      };
    });
  };
}
