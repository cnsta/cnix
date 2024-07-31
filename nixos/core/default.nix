{pkgs, ...}: {
  imports = [
    ./system
    ./xdg.nix
    ./zsh.nix
    ./fonts.nix
    ./home-manager.nix
    ./hyprland.nix
  ];
  security = {
    rtkit.enable = true;
    pam.services.hyprlock = {};
  };

  programs.dconf.enable = true;

  environment.localBinInPath = true;

  console.useXkbConfig = true;
  environment.systemPackages = with pkgs; [
    anyrun
    stow
  ];
}
