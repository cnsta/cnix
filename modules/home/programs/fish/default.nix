{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasEza = hasPackage "eza";
  cfg = config.home.programs.fish;
in
{
  options = {
    home.programs.fish.enable = mkEnableOption "Enables fish home configuration";
  };
  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      plugins = [
        {
          name = "hydro";
          src = pkgs.fishPlugins.hydro;
        }
      ];
      shellAbbrs = {
        extract = "extract.sh";
        nixclean = "nh clean all --keep 3";
        nixdev = "nix develop ~/.nix-config -c $SHELL";
        nixup = "nh os switch -H $hostname";
        nixupn = "nh os switch -n -H $hostname";
        nixupv = "nh os switch -v --show-trace -H $hostname";
        nixupvn = "nh os switch -n -v --show-trace -H $hostname";
        flakeup = "nix flake update";
      };
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
        nixconfig = "cd /home/$USER/.nix-config/";
        homemodules = "$EDITOR /home/$USER/.nix-config/users/$USER/modules/{$hostname}mod.nix";
        hmod = "$EDITOR /home/$USER/.nix-config/users/$USER/modules/{$hostname}mod.nix";
        nixsettings = "$EDITOR /home/$USER/.nix-config/hosts/$hostname/settings.nix";
        nset = "$EDITOR /home/$USER/.nix-config/hosts/$hostname/settings.nix";
        nixosmodules = "$EDITOR /home/$USER/.nix-config/hosts/$hostname/modules.nix";
        nmod = "$EDITOR /home/$USER/.nix-config/hosts/$hostname/modules.nix";
        ls = mkIf hasEza "eza";
        tree = mkIf hasEza "eza --tree --icons=always";
        # Clear screen and scrollback
        clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      };
      functions = {
        # Disable greeting
        fish_greeting = "";
        # Merge history when pressing up
        up-or-search = lib.readFile ./up-or-search.fish;
        # Check stuff in PATH
        nix-inspect = # fish
          ''
            set -s PATH | grep "PATH\[.*/nix/store" | cut -d '|' -f2 |  grep -v -e "-man" -e "-terminfo" | perl -pe 's:^/nix/store/\w{32}-([^/]*)/bin$:\1:' | sort | uniq
          '';
      };
      interactiveShellInit = # fish
        ''
          # Open command buffer in vim when alt+e is pressed
          bind \ee edit_command_buffer

          # Use vim bindings and cursors
          fish_vi_key_bindings
          set fish_cursor_default     block      blink
          set fish_cursor_insert      line       blink
          set fish_cursor_replace_one underscore blink
          set fish_cursor_visual      block

          # Use terminal colors
          set -x fish_color_autosuggestion      brblack
          set -x fish_color_cancel              -r
          set -x fish_color_command             brgreen
          set -x fish_color_comment             brmagenta
          set -x fish_color_cwd                 green
          set -x fish_color_cwd_root            red
          set -x fish_color_end                 brmagenta
          set -x fish_color_error               brred
          set -x fish_color_escape              brcyan
          set -x fish_color_history_current     --bold
          set -x fish_color_host                normal
          set -x fish_color_host_remote         yellow
          set -x fish_color_match               --background=brblue
          set -x fish_color_normal              normal
          set -x fish_color_operator            cyan
          set -x fish_color_param               brblue
          set -x fish_color_quote               yellow
          set -x fish_color_redirection         bryellow
          set -x fish_color_search_match        'bryellow' '--background=brblack'
          set -x fish_color_selection           'white' '--bold' '--background=brblack'
          set -x fish_color_status              red
          set -x fish_color_user                brgreen
          set -x fish_color_valid_path          --underline
          set -x fish_pager_color_completion    normal
          set -x fish_pager_color_description   yellow
          set -x fish_pager_color_prefix        'white' '--bold' '--underline'
          set -x fish_pager_color_progress      'brwhite' '--background=cyan'

          microfetch
        '';
    };
  };
}
