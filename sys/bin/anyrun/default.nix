{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.anyrun
  ];
}
