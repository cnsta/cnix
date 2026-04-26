{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  common = import ../../../nixos/programs/fish/common.nix { inherit lib; };
  cfg = config.home.programs.fish;
  hasPackage = name: lib.any (p: (p.pname or p.name or null) == name) config.home.packages;
  hasEza = hasPackage "eza";
in
{
  options.home.programs.fish.enable = mkEnableOption "fish (user)";

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.carapace = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;

      shellAbbrs = common.abbrs;

      shellAliases =
        common.aliases
        // lib.optionalAttrs hasEza {
          ls = "eza";
          tree = "eza --tree --icons=always";
        };

      functions = common.functions // {
        up-or-search = lib.readFile ./up-or-search.fish;
        nix-inspect = ''
          set -s PATH | grep "PATH\[.*/nix/store" | cut -d '|' -f2 \
            | grep -v -e "-man" -e "-terminfo" \
            | perl -pe 's:^/nix/store/\w{32}-([^/]*)/bin$:\1:' \
            | sort | uniq
        '';
      };

      interactiveShellInit = common.interactiveInit;
    };
  };
}
