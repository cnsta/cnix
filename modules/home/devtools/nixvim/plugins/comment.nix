{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.home.devtools.nixvim.plugins.comment;
in {
  options = {
    home.devtools.nixvim.plugins.comment.enable = mkEnableOption "Enables Comment plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.comment = {
      enable = true;

      settings = {
        opleader.line = "<C-b>";
        toggler.line = "<C-b>";
      };
    };
  };
}
