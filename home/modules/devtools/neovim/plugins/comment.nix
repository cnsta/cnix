{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.comment;
in
{
  options = {
    modules.devtools.neovim.plugins.comment.enable = mkEnableOption "Enables Comment plugin for Neovim";
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
