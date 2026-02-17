{
  config,
  osConfig,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.nushell;
in
{
  imports = [
  ];
  options = {
    home.programs.nushell.enable = mkEnableOption "Enables nushell home configuration";
  };
  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      settings = {
        buffer_editor = config.home.sessionVariables.EDITOR;
        show_banner = false;
        completions = {
          algorithm = "prefix";
          quick = true;
        };
      };
      environmentVariables = {
        HOSTNAME = osConfig.networking.hostName;
      };
      extraConfig = /* nu */ ''
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

            if $dry_run {
                $args = ($args | append "-n")
            }

            if $verbose {
                $args = ($args | append ["-v" "--show-trace"])
            }

            ^nh ...$args
        }
      '';
      shellAliases = {
        extract = "extract.sh";
        nixclean = "nh clean all --keep 3";
        flakeup = "nix flake update";
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
      };
    };
  };
}
