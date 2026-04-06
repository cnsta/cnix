{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.nushell;

  # This is a custom setting, replace with your own username: `user = "yourusername";`
  user = config.settings.accounts.username;

  hmVars =
    if options ? home-manager && config.home-manager.users ? ${user} then
      config.home-manager.users.${user}.home.sessionVariables
    else
      { };

  envVars =
    config.environment.variables
    // config.environment.sessionVariables
    // hmVars
    // {
      HOSTNAME = config.networking.hostName;
      PROMPT_INDICATOR_VI_NORMAL = "";
      PROMPT_INDICATOR_VI_INSERT = "";
    };

  # toNushell serializer, from home-manager lib/nushell.nix
  toNushell =
    {
      indent ? "",
      multiline ? true,
    }@args:
    v:
    let
      innerIndent = "${indent}    ";
      introSpace = if multiline then "\n${innerIndent}" else " ";
      outroSpace = if multiline then "\n${indent}" else " ";
      innerArgs = args // {
        indent = innerIndent;
      };
      concatItems = lib.concatStringsSep introSpace;
      recurse = toNushell innerArgs;
    in
    if v == null then
      "null"
    else if lib.isInt v || lib.isFloat v || lib.isBool v || lib.isString v then
      lib.strings.toJSON v
    else if lib.isList v then
      if v == [ ] then "[]" else "[${introSpace}${concatItems (map recurse v)}${outroSpace}]"
    else if lib.isAttrs v then
      if lib.isDerivation v then
        toString v
      else if v == { } then
        "{}"
      else
        "{${introSpace}${
          concatItems (lib.mapAttrsToList (k: v: "${lib.strings.toJSON k}: ${recurse v}") v)
        }${outroSpace}}"
    else
      throw "toNushell: unsupported type ${lib.typeOf v}";

  mkLoadEnv =
    vars:
    let
      pairs = lib.mapAttrsToList (k: v: "    ${lib.strings.toJSON k}: ${toNushell { } v}") vars;
    in
    ''
      load-env {
      ${lib.concatStringsSep "\n" pairs}
      }
    '';

  # Integration scripts
  starshipInit = pkgs.runCommand "starship-nushell-config.nu" { } ''
    ${pkgs.starship}/bin/starship init nu > $out
  '';

  carapaceInit =
    pkgs.runCommand "carapace-nushell-config.nu"
      {
        HOME = "/home/${user}";
      }
      ''
        ${pkgs.carapace}/bin/carapace _carapace nushell > $out
      '';

  # File builders
  envNu = pkgs.writeText "nushell-env-${user}.nu" ''
    ${mkLoadEnv envVars}

    $env.GPG_TTY = (tty)
    ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye | ignore
    $env.SSH_AUTH_SOCK = (
        $env.SSH_AUTH_SOCK?
        | default (${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
    )
  '';

  configNu = pkgs.writeText "nushell-config-${user}.nu" ''
    let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
    }

    $env.config = {
        show_banner: false
        edit_mode: "vi"
        buffer_editor: "hx"
        cursor_shape: {
            vi_insert: "line"
            vi_normal: "block"
        }
        completions: {
            algorithm: "prefix"
            case_sensitive: false
            quick: true
            partial: true
            external: {
                enable: true
                max_results: 100
                completer: $carapace_completer
            }
        }
    }

    $env.PATH = (
        $env.PATH
        | split row (char esep)
        | prepend $"($env.HOME)/.apps"
    )

    def hmod [] {
        ^$env.EDITOR $"($env.HOME)/.nix-config/users/($env.USER)/modules/($env.HOSTNAME)mod.nix"
    }
    def nset [] {
        ^$env.EDITOR $"($env.HOME)/.nix-config/hosts/($env.HOSTNAME)/settings.nix"
    }
    def nmod [] {
        ^$env.EDITOR $"($env.HOME)/.nix-config/hosts/($env.HOSTNAME)/modules.nix"
    }
    def nsrv [] {
        ^$env.EDITOR $"($env.HOME)/.nix-config/hosts/sobotka/server.nix"
    }
    def --env nixconfig [] {
        cd ~/.nix-config/
    }
    def fnix [...pkgs] {
        ^nix-shell -p ...$pkgs --run nu
    }
    def nixup [
        --dry-run (-n)
        --verbose (-v)
    ] {
        mut args = ["os" "switch" "-H" $env.HOSTNAME]
        if $dry_run { $args = ($args | append "-n") }
        if $verbose { $args = ($args | append ["-v" "--show-trace"]) }
        ^nh ...$args
    }
    def --env y [...args] {
        let tmp = (mktemp -t "yazi-cwd.XXXXX")
        ^yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp)
        if $cwd != "" and $cwd != $env.PWD { cd $cwd }
        rm -fp $tmp
    }

    alias ".."     = cd ..
    alias "..."    = cd ../../
    alias "...."   = cd ../../../
    alias "....."  = cd ../../../../
    alias "......" = cd ../../../../../
    alias extract  = extract.sh
    alias eza      = eza --git --group-directories-first --header --icons
    alias flakeup  = nix flake update
    alias nixclean = nh clean all --keep 3

    use ${starshipInit}
    source ${carapaceInit}

    $env.config = ($env.config? | default {})
    $env.config.hooks = ($env.config.hooks? | default {})
    $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt?
        | default []
        | append {||
            ${pkgs.direnv}/bin/direnv export json
            | from json --strict
            | default {}
            | items {|key, value|
                let value = do (
                    {
                        "PATH": {
                            from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                            to_string:   {|v| $v | path expand --no-symlink | str join (char esep) }
                        }
                    }
                    | merge ($env.ENV_CONVERSIONS? | default {})
                    | get ([[value, optional, insensitive]; [$key, true, true] [from_string, true, false]] | into cell-path)
                    | if ($in | is-empty) { {|x| $x} } else { $in }
                ) $value
                return [ $key $value ]
            }
            | into record
            | load-env
        }
    )
  '';

in
{
  options.nixos.programs.nushell = {
    enable = mkEnableOption "system-level nushell configuration";
  };

  config = mkIf cfg.enable {
    environment = {
      shells = [ pkgs.nushell ];
      systemPackages = [
        pkgs.nushell
        pkgs.carapace
        pkgs.direnv
      ];
    };

    programs = {
      starship.enable = true;
      bash.interactiveShellInit = ''
        if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
          exec nu
        fi
      '';
    };

    systemd.tmpfiles.rules = [
      "d  /home/${user}/.config/nushell         0755 ${user} users -"
      "L+ /home/${user}/.config/nushell/env.nu    -  ${user} users - ${envNu}"
      "L+ /home/${user}/.config/nushell/config.nu -  ${user} users - ${configNu}"
    ];
  };
}
