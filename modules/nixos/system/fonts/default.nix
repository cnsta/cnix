{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.nixos.system.fonts;
in
{
  options = {
    nixos.system.fonts = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable various font packages";
      };
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages =
        (with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          liberation_ttf
          fira-code-symbols
          font-awesome
          recursive
          input-fonts
          source-code-pro
          ibm-plex
          inter
        ])
        ++ (with pkgs.nerd-fonts; [
          jetbrains-mono
          departure-mono
          fira-code
          fira-mono
          iosevka
          _3270
          droid-sans-mono
          ubuntu-mono
          overpass
          monoid
          mononoki
          hack
          tinos
          symbols-only
        ])
        ++ [
          inputs.fonts.packages.${pkgs.stdenv.hostPlatform.system}.vcr-mono
        ];

      fontconfig.defaultFonts = {
        serif = [ "Tinos" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Input Mono Narrow Light" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
