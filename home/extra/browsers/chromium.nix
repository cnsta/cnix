{
  programs.chromium = {
    enable = true;
    extraOpts = {
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "se"
        "en-US"
      ];
    };
    extensions = ''
        [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
          "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
          "gebbhagfogifgggkldgodflihgfeippi" # return dislike
          "ponfpcnoihfmfllpaingbgckeeldkhle" # enhancer for youtube
      ]
    '';
  };
}
