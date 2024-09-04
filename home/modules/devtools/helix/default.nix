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
  imports = [
    ./lang.nix
    ./theme.nix
  ];

  options = {
    modules.devtools.helix.enable = mkEnableOption "Enable helix";
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.default;

      settings = {
        theme = "gruvbox_custom";
        editor = {
          color-modes = true;
          scrolloff = 0;
          cursorline = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = false;
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

        keys = let
          spaceMode = {
            space = "file_picker";
            n = "global_search";
            f = ":format";
            c = "toggle_comments";
            t = {
              d = "goto_type_definition";
              i = "goto_implementation";
              r = "goto_reference";
              t = "goto_definition";
              w = "trim_selections";
            };
            x = ":buffer-close";
            w = ":w";
            q = ":q";
            y = "yank";
            p = "paste_after";
            P = "paste_before";
            R = "replace_with_yanked";
          };
        in {
          normal = {
            y = "yank_to_clipboard";
            p = "paste_clipboard_after";
            C-a = "select_all";
            del = "delete_selection";
            space = spaceMode;
          };
          insert = {
            C-v = "paste_clipboard_after";
            C-c = "yank_to_clipboard";
          };
          select = {
            space = spaceMode;
          };
        };
      };
    };
  };
}
