{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.devtools.helix;
in {
  imports = [
    ./lang.nix
    ./theme.nix
  ];

  options = {
    userModules.devtools.helix.enable = mkEnableOption "Enable helix";
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      # package = inputs.helix.packages.${pkgs.system}.default;
      package = inputs.helix-flake.packages.${pkgs.system}.default;

      settings = {
        theme = "gruvbox_custom";
        editor = {
          color-modes = true;
          scrolloff = 0;
          cursorline = true;
          completion-replace = true;
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
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
          statusline = {
            separator = "of";
            left = [
              "mode"
              "selections"
              "file-type"
              "register"
              "spinner"
              "diagnostics"
            ];
            center = ["file-name"];
            right = [
              "file-encoding"
              "file-line-ending"
              "position-percentage"
              "spacer"
              "separator"
              "total-line-numbers"
            ];
            mode = {
              normal = "NOR";
              insert = "INS";
              select = "SEL";
            };
          };
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
            d = {
              d = ["extend_to_line_bounds" "yank_main_selection_to_clipboard" "delete_selection"];
              s = ["surround_delete"];
            };
            x = "delete_selection";
            y = {
              y = ["extend_to_line_bounds" "yank_main_selection_to_clipboard" "normal_mode" "collapse_selection"];
              d = ":yank-diagnostic";
            };
            Y = ["extend_to_line_end" "yank_main_selection_to_clipboard" "collapse_selection"];
            P = ["paste_clipboard_before" "collapse_selection"];
            p = ["paste_clipboard_after" "collapse_selection"];
            C-a = "select_all";
            del = "delete_selection";
            space = spaceMode;
          };
          insert = {
            C-v = "paste_clipboard_after";
            C-c = "yank_to_clipboard";
            C-x = "completion";
            del = "delete_selection";
            esc = ["collapse_selection" "normal_mode"];
          };
          select = {
            space = spaceMode;
            d = ["yank_main_selection_to_clipboard" "delete_selection"];
            x = ["yank_main_selection_to_clipboard" "delete_selection"];
            y = ["yank_main_selection_to_clipboard" "normal_mode" "flip_selections" "collapse_selection"];
            Y = ["extend_to_line_bounds" "yank_main_selection_to_clipboard" "goto_line_start" "collapse_selection" "normal_mode"];
            p = ["replace_selections_with_clipboard"];
            P = ["paste_clipboard_before"];
          };
        };
      };
    };
  };
}
