{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.chromium;
in {
  options = {
    home.programs.chromium.enable = mkEnableOption "Enables chromium";
  };
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = [
        "gebbhagfogifgggkldgodflihgfeippi" # return youtube dislike
        "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock for youtube
        "ponfpcnoihfmfllpaingbgckeeldkhle" # enhancer for youtube
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      ];
    };
  };
}
