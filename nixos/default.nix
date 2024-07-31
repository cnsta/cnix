let
  shared = [
    ./core

    ./locale

    ./services/audio
    ./services/greetd
    ./services/gnome-keyring
    ./services/gvfs
    ./services/locate
    ./services/mullvad
    ./services/openssh
    ./services/power
    ./services/samba
    ./services/udisks
  ];

  laptop =
    shared
    ++ [
      ./services/fwupd
    ];
  cnix =
    shared
    ++ [
      ./core/system/cnix-nh.nix
    ];
  toothpc =
    shared
    ++ [
      ./core/system/toothpc-nh.nix
    ];
in {
  inherit shared laptop cnix toothpc;
}
