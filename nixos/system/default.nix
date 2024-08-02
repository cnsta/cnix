{pkgs, ...}: {
  imports = [
    ./etc
    ./shell/sh
  ];

  console.useXkbConfig = true;
  environment.systemPackages = with pkgs; [
    anyrun
  ];
}
