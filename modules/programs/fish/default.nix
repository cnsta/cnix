{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.fish;
  acct = config.cnix.settings.accounts;
  common = import ./common.nix;

  ezaPkgs = [ pkgs.eza ];
  ezaInit = ''
    if command -q eza
        alias ls eza
        alias tree 'eza --tree --icons=always'
    end
  '';

  abbrsToFish =
    abbrs: concatStringsSep "\n" (mapAttrsToList (n: v: "abbr -a ${n} -- ${escapeShellArg v}") abbrs);

  aliasesToFish =
    aliases: concatStringsSep "\n" (mapAttrsToList (n: v: "alias ${n} ${escapeShellArg v}") aliases);

  hasUsers = acct.defaultUsers != [ ];
in
{
  options.cnix.programs.fish = {
    enable = mkEnableOption "fish (system-wide)";
    homeless.enable = mkEnableOption "system-level fish dotfiles for hosts without per-user config";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.fish = {
        enable = true;
        useBabelfish = true;
        vendor = {
          completions.enable = true;
          config.enable = true;
          functions.enable = true;
        };
      };
    }

    (mkIf cfg.homeless.enable {
      environment.systemPackages = ezaPkgs ++ [
        pkgs.carapace
        pkgs.starship
      ];
      programs.starship.enable = true;
      programs.fish = {
        shellAbbrs = common.abbrs;
        shellAliases = common.aliases;
        interactiveShellInit = ''
          ${common.interactiveInit}
          ${ezaInit}
          ${getExe pkgs.carapace} _carapace fish | source
        '';
      };
    })

    (mkIf hasUsers {
      hjem.users = genAttrs acct.defaultUsers (_: {
        packages = ezaPkgs ++ [
          pkgs.carapace
          pkgs.starship
        ];

        xdg.config.files = {
          "fish/conf.d/00-abbrs.fish".text = abbrsToFish common.abbrs;
          "fish/conf.d/01-aliases.fish".text = aliasesToFish common.aliases;

          "fish/conf.d/02-interactive.fish".text = ''
            if status is-interactive
            ${common.interactiveInit}
            ${ezaInit}
            end
          '';

          "fish/conf.d/03-starship.fish".text = ''
            if status is-interactive
                starship init fish | source
            end
          '';

          "fish/conf.d/04-carapace.fish".text = ''
            if status is-interactive
                carapace _carapace fish | source
            end
          '';

          "fish/functions/up-or-search.fish".source = ./up-or-search.fish;

          "fish/functions/fish_greeting.fish".text = ''
            function fish_greeting
            end
          '';

          "fish/functions/nix-inspect.fish".text = ''
            function nix-inspect
                set -s PATH | grep "PATH\[.*/nix/store" | cut -d '|' -f2 \
                    | grep -v -e "-man" -e "-terminfo" \
                    | perl -pe 's:^/nix/store/\w{32}-([^/]*)/bin$:\1:' \
                    | sort | uniq
            end
          '';
        };
      });
    })
  ]);
}
