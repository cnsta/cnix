{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = {
    # see profiles/desktop-<foo>.nix for xdg-portal stuff

    home-manager.users.cnst =
      { pkgs, ... }:
      {
        home.packages =
          with pkgs;
          [ xdg-user-dirs ]
          ++ (lib.optionals (pkgs.stdenv.hostPlatform.system != "riscv64-linux") [ xdg-utils ]);
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            desktop = "$HOME/desktop";
            documents = "$HOME/documents";
            download = "$HOME/downloads";
            music = "$HOME/documents/music";
            pictures = "$HOME/documents/images";
            publicShare = "$HOME/documents/share";
            templates = "$HOME/documents/templates";
            videos = "$HOME/documents/videos";
          };
        };
      };
  };
}
