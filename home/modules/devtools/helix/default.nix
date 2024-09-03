{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.devtools.helix;
in {
  imports = [./languages.nix];

  options = {
    modules.devtools.helix.enable = mkEnableOption "Enable helix";
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.default;

      settings = {
        theme = "gruvbox_material_dark_soft";
        editor = {
          color-modes = true;
          cursorline = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
          inline-diagnostics = {
            cursor-line = "hint";
            other-lines = "error";
          };
          lsp.display-inlay-hints = true;
          statusline.center = ["position-percentage"];
          true-color = true;
          whitespace.characters = {
            newline = "↴";
            tab = "⇥";
          };
        };

        keys = {
          normal = {
            y = "yank_to_clipboard";
            p = "paste_clipboard_after";
            space.u = {
              f = ":format"; # format using LSP formatter
              w = ":set whitespace.render all";
              W = ":set whitespace.render none";
            };
          };
          insert = {
            C-v = "paste_clipboard_after";
          };
        };
      };
    };
  };
}
