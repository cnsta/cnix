{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    anyrun
    stow
  ];
}
