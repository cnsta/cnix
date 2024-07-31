{pkgs, ...}: {
  imports = [
    ./system
    ./xdg.nix
    ./zsh.nix
    ./fonts.nix
    ./home-manager.nix
    ./hyprland.nix
  ];

  programs.dconf.enable = true;

  console.useXkbConfig = true;
  environment.systemPackages = with pkgs; [
    anyrun
  ];
}
