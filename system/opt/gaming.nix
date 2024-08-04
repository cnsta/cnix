{pkgs, ...}: {
  imports = [
    ./steam
    ./lutris
    # ./bottles
    ./gamemode
    ./gamescope
    ./corectrl
  ];
  environment = {
    systemPackages = with pkgs; [
      # Misc
      protonup
      winetricks
    ];
  };
}
