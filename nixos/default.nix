let
  shared = [
    ./system

    ./locale

    ./srv/audio
    ./srv/greetd
    ./srv/gnome-keyring
    ./srv/gvfs
    ./srv/locate
    ./srv/mullvad
    ./srv/openssh
    ./srv/power
    ./srv/samba
    ./srv/udisks
    ./srv/fwupd
  ];

  adampad =
    shared
    ++ [
      ./system/var/nh/adampad.nix
      ./srv/xserver/adampad.nix
      ./hardware/adampad.nix
    ];
  cnix =
    shared
    ++ [
      ./system/var/nh/cnix.nix
      ./srv/xserver/cnix.nix
      ./hardware/cnix.nix
    ];
  toothpc =
    shared
    ++ [
      ./system/var/nh/toothpc.nix
      ./srv/xserver/toothpc.nix
      ./hardware/toothpc.nix
    ];
in {
  inherit shared adampad cnix toothpc;
}
