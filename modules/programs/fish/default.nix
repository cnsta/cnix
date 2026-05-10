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
  common = import ./common.nix { inherit pkgs lib; };

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
      environment.systemPackages = with pkgs; [
        eza
        carapace
        starship
      ];
      programs.starship.enable = true;
      programs.fish = {
        shellAbbrs = common.abbrs;
        shellAliases = common.aliases;
        interactiveShellInit = ''
          ${common.interactiveInit}
          ${getExe pkgs.carapace} _carapace fish | source
        '';
      };
    })

    (mkIf hasUsers {
      hjem.users = genAttrs acct.defaultUsers (_: {
        packages = with pkgs; [
          eza
          carapace
          starship
        ];
        xdg.config.files = {
          "fish/config.fish".text = ''
            ${abbrsToFish common.abbrs}
            ${aliasesToFish common.aliases}
            if status is-interactive
            ${common.interactiveInit}
                starship init fish | source
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
