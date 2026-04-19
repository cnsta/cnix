{ lib, ... }:
{
  abbrs = {
    us = "systemctl --user";
    rs = "sudo systemctl";
  };

  aliases = {
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
    nixconfig = "cd $NH_FLAKE/";
    hmod = "$EDITOR $NH_FLAKE/users/$USER/modules/{$hostname}mod.nix";
    nset = "$EDITOR $NH_FLAKE/hosts/$hostname/settings.nix";
    nmod = "$EDITOR $NH_FLAKE/hosts/$hostname/modules.nix";
    nsrv = "$EDITOR $NH_FLAKE/hosts/sobotka/server.nix";
    fnix = "nix-shell --run fish -p";
    extract = "extract.sh";
    flakeup = "nix flake update";
    nixclean = "nh clean all --keep 3";
    nixdev = "nix develop $NH_FLAKE -c $SHELL";
    nixup = "nh os switch -d always -H $hostname";
    nixupn = "nh os switch -d always -n -H $hostname";
    nixupv = "nh os switch -d always -v --show-trace -H $hostname";
    nixupvn = "nh os switch -d always -n -v --show-trace -H $hostname";
    clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
    reboot = "systemctl reboot";
    shutdown = "systemctl poweroff";
  };

  interactiveInit = ''
    # alt+e: edit current command in $EDITOR
    bind \ee edit_command_buffer

    # vi mode with sensible cursors
    fish_vi_key_bindings
    set fish_cursor_default     block      blink
    set fish_cursor_insert      line       blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual      block

    # Terminal colours
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
  '';

  functions = {
    fish_greeting = "";
  };
}
