{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    filterAttrs
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  serviceModule =
    { name, config, ... }:
    {
      options = {
        enable = mkEnableOption "runit user service" // {
          default = true;
        };

        name = mkOption {
          type = types.str;
          description = ''
            Name of the service. Determines the directory created under
            {file}`~/service/`. Defaults to the attribute name.
          '';
        };

        run = mkOption {
          type = types.lines;
          description = ''
            Shell commands for the {file}`run` script. The final statement
            must `exec` into the daemon process, runit supervises by holding
            that PID. If the process exits, runit restarts the service.
          '';
        };

        finish = mkOption {
          type = types.nullOr types.lines;
          default = null;
          description = ''
            Optional {file}`finish` script, executed after the supervised
            process exits. Receives the exit code as `$1` and the signal
            number (or `-1` if exited normally) as `$2`.
          '';
        };

        conf = mkOption {
          type = types.nullOr types.lines;
          default = null;
          description = ''
            Optional {file}`conf` file, intended to be sourced by {file}`run`
            to export environment variables before the `exec`. Not executed
            directly — add `. ./conf` near the top of your run script.

            Example:
            ```
            conf = "export GNUPGHOME=/home/user/.gnupg";
            run  = ". ./conf\nexec gpg-agent --no-detach";
            ```
          '';
        };

        log = {
          enable = mkEnableOption "svlogd logging for this service";

          run = mkOption {
            type = types.lines;
            default = "exec svlogd -tt ./main";
            description = ''
              Shell commands for {file}`log/run`. The default pipes stdout
              through svlogd with timestamps into {file}`log/main/`.
            '';
          };
        };
      };

      # Mirror the nixpkgs submodule convention: the name attribute
      # defaults to the attrset key but can be overridden.
      config.name = mkDefault name;
    };

  cfg = config.home.runit;

  # Only process services that are actually enabled, keeping the generated
  # home.file attrset clean.
  enabledServices = filterAttrs (_: svc: svc.enable) cfg.services;

  # Produce the home.file entries for one service. Returns an attrset
  # ready to be merged into home.file.
  mkServiceFiles =
    name: svc:
    # run is always present
    {
      "service/${name}/run".source = pkgs.writeShellScript "${name}-run" svc.run;
    }
    # finish only if defined
    // lib.optionalAttrs (svc.finish != null) {
      "service/${name}/finish".source = pkgs.writeShellScript "${name}-finish" svc.finish;
    }
    # conf is sourced, not executed. Plain text, no executable bit
    // lib.optionalAttrs (svc.conf != null) {
      "service/${name}/conf".text = svc.conf;
    }
    # log/run only if logging is enabled
    // lib.optionalAttrs svc.log.enable {
      "service/${name}/log/run".source = pkgs.writeShellScript "${name}-log-run" svc.log.run;
    };
in
{
  options.home.runit = {
    enable = mkEnableOption "runit user services";

    services = mkOption {
      type = types.attrsOf (types.submodule serviceModule);
      default = { };
      description = ''
        User runit services. Each service is materialised under
        {file}`~/service/<name>/` as symlinks into the Nix store.
        runit creates its {file}`supervise/` control directory alongside
        these symlinks at runtime, which is why the parent directory must
        remain mutable. Home-manager's per-file symlink approach satisfies
        this naturally.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.file = mkMerge (mapAttrsToList mkServiceFiles enabledServices);
  };
}
