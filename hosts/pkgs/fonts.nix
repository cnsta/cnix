{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code-symbols
    font-awesome
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
        "Iosevka"
        "3270"
        "DroidSansMono"
      ];
    })
  ];
}
