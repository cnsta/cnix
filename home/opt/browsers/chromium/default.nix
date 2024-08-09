{pkgs, ...}: {
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
}
