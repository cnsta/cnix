# cnix

> [!NOTE]
> This repository's listed contributors are bugged after I accidentally force
> pushed a cloned repo.

My NixOS daily driver. Desktop running on
[River](https://codeberg.org/river/river) and my own window manager,
[delta](https://github.com/cnsta/delta), currently in alpha state. The
configuration leans on small per-tool modules with a tiny custom helper (`clib`)
for host-scoped enables.

Some tools and apps I use:

- **[nh](https://github.com/viperML/nh)**: A pretty cool "nix helper".
- **[agenix](https://github.com/ryantm/agenix)**: Age-based encryption.
- **[hjem](https://github.com/feel-co/hjem)**: Nix home management.
- **[helix](https://github.com/helix-editor/helix)**: Neat vim-like editor.
- **[kanata](https://github.com/jtroo/kanata)**: Keyboard mapping, good stuff.
- **[ashell](https://github.com/MalpenZibo/ashell)**: Status bar without
  needless bloat.
- **[fuzzel](https://codeberg.org/dnkl/fuzzel)**: App launcher, does what it
  says.
- **[microfetch](https://github.com/NotAShelf/microfetch)**: It's neofetch but
  better.
- **[river](https://codeberg.org/river/river)**: Awesome wlroots compositor.
- **[delta](https://github.com/cnsta/delta)**: Simple, with one job: to manage
  windows.
- **[byt](https://github.com/cnsta/byt)**: A little VPN switcher I wrote.
- **[litecrazy](https://github.com/cnsta/litecrazy)**: VERY niche mouse
  software.

## Hosts

- **bunk**: Thinkpad, L13 or thereabouts.
- **kima**: Main desktop. 9950X, 6950 XT.
- **sobotka**: Homelab server. 3950X, Intel B580, Radeon Pro W5700.
- **toothpc**: Brother's desktop. Intel CPU, Nvidia GPU.
- **ziggy**: Raspberry Pi running secondary pihole and unbound.

## Structure

Quick map of the repository. Might not be 100% up to date.

```
hosts/        # Per-host configs (hardware, settings, hjem)
lib/          # Custom helpers etc
modules/
├ programs/   # Various program modules
├ services/   # Various service modules
├ server/     # Homelab modules, sobotka and ziggy exclusive
└ settings/   # Cross-cutting option declarations
pkgs/         # Custom packages
scripts/      # Shell scripts
secrets/      # Agenix-encrypted secrets
system/       # Flake-level wiring (users, variables, substituters)
```

The shared `modules.nix` file in `modules/settings/` is a frequent edit point.
Every supported module appears once, host-scoped via single-letter shorthands
(`k` = kima, `s` = sobotka, etc.).

## Inspiration

Much credit goes to the folks below, great resources! You'll find I've yanked
plenty from them.

- **[fufexan](https://github.com/fufexan/dotfiles.git)**
- **[Misterio77](https://github.com/Misterio77/nix-config.git)**
- **[NotAShelf](https://github.com/NotAShelf)**
- **[hlissner](https://github.com/hlissner/dotfiles)**
