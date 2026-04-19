{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  common = import ./common.nix { inherit lib; };
  cfg = config.nixos.programs.fish;
in
{
  options.nixos.programs.fish = {
    enable = mkEnableOption "system-level fish";
    homeless.enable = mkEnableOption "full fish config at system level (no home-manager)";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.fish = {
        enable = true;
        useBabelfish = true;
        vendor = {
          completions.enable = true;
          config.enable = true;
          functions.enable = true;
        };
      };
    })

    (mkIf cfg.homeless.enable {
      environment.systemPackages = with pkgs; [
        eza
        carapace
      ];

      programs.starship.enable = true;

      programs.fish = {
        shellAbbrs = common.abbrs;
        shellAliases = common.aliases // {
          ls = lib.getExe pkgs.eza;
          tree = "${lib.getExe pkgs.eza} --tree --icons=always";
        };

        interactiveShellInit = common.interactiveInit + ''

          ${pkgs.carapace}/bin/carapace _carapace fish | source
        '';
      };
    })
  ];
}
