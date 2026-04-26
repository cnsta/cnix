# cnix

My NixOS daily driver. Started as a single-machine
**[Hyprland](https://hyprland.org/)** desktop and grew sideways, more
workstations, a Raspberry Pi, and a homelab server. The configuration leans on
small per-tool modules with a tiny custom helper (`clib`) for host-scoped
enables.

Some tools and apps I use:

- **[nh](https://github.com/viperML/nh)** _A pretty cool "nix helper"._
- **[agenix](https://github.com/ryantm/agenix)** _Age-based encryption._
- **[kanata](https://github.com/jtroo/kanata)** _Keyboard mapping, good stuff._
- **[quickshell](https://quickshell.outfoxxed.me/)** _Wayland shell, replaced
  waybar._
- **[zen-browser](https://github.com/zen-browser/desktop)** _Beta-stage
  Firefox-based browser._
- **[fuzzel](https://codeberg.org/dnkl/fuzzel)** _App launcher, does what it
  says._
- **[helix](https://github.com/helix-editor/helix)** _Neat vim-like editor._
- **[microfetch](https://github.com/NotAShelf/microfetch)** _It's neofetch but
  better._
- **[tailscale](https://tailscale.com/)** _Mesh VPN holding the fleet together._

## Hosts

- **bunk** _Thinkpad, L13 or thereabouts._
- **kima** _Main desktop. 9950X, 6950 XT._
- **sobotka** _Homelab server. 3950X, Intel B580, Radeon Pro W5700._
- **toothpc** _Brother's desktop. Intel CPU, Nvidia GPU._
- **ziggy** _Raspberry Pi running secondary pihole and unbound._

## Structure

Quick map of the repository. Might not be 100% up to date.

```
hosts/        # Per-host configs (hardware, settings)
lib/          # Custom helpers etc
modules/
├ home/       # Home-manager modules
├ nixos/      # Core OS and system-wide modules
├ server/     # Homelab modules, sobotka and ziggy exclusive
└ settings/   # Cross-cutting option declarations
pkgs/         # Custom packages
scripts/      # Shell scripts
secrets/      # Agenix-encrypted secrets
system/       # Flake-level wiring (users, home-manager, substituters)
users/        # Per-user HM configs
```

The shared `modules.nix` files in `modules/nixos/` and `modules/home/` are
frequent edit points. Every supported module appears once, host-scoped via
single-letter shorthands (`k` = kima, `s` = sobotka, etc.).

## Inspiration

Much credit goes to the folks below, great resources! You'll find I've yanked
plenty from them.

- **[fufexan](https://github.com/fufexan/dotfiles.git)**
- **[Misterio77](https://github.com/Misterio77/nix-config.git)**
- **[NotAShelf](https://github.com/NotAShelf)**
- **[hlissner](https://github.com/hlissner/dotfiles)**
