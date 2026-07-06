# cnix fresh-install guide

Template for wiping any host and reinstalling straight from the flake, no
intermediate "throwaway" NixOS install, and the very first build pulls from
cache.cnst.dev.

Throughout this guide, `$HOST` is the host being installed and `$USER` is your
username. Examples use `bunk` (laptop, LUKS + XFS). Commands prefixed `desktop$`
run on another machine (e.g. kima); `iso$` runs in the live environment over
SSH.

## 0. Before you wipe (do this on the old install!)

The single most important step. `secrets/keys.nix` encrypts agenix secrets
against `hosts/$HOST/ssh_host_ed25519_key.pub`. If you save the host key now,
the new install decrypts everything immediately and **no rekeying is needed**.

```bash
# On the machine being wiped, copy the host key somewhere safe:
scp /etc/ssh/ssh_host_ed25519_key* $USER@kima:~/keys-$HOST/
```

Also grab anything else stateful you care about: `~/.ssh/`, browser profiles,
`~/Documents`, etc. If you forget the host key, see **Appendix A: Rekeying**.

## 1. Boot the ISO and get SSH access

1. Boot the standard NixOS minimal ISO (graphical works too, minimal is enough).
2. On the live console, set a password so you can SSH in:

   ```bash
   passwd            # sets password for the 'nixos' user; sshd is already running
   ip a              # note the IP
   ```

3. From your desktop:

   ```bash
   desktop$ ssh nixos@<ip>
   iso$ sudo -i
   ```

Everything below happens over this SSH session, comfy keyboard, copy-paste, no
typing on the target machine.

## 2. Partition, encrypt, format

Reference layout: EFI boot partition, encrypted swap, and a LUKS container
holding an XFS root. Adjust sizes per host (swap ≈ RAM size if you want
hibernation, smaller otherwise).

```bash
export HOST=bunk
export USER=cnst
export DISK=/dev/nvme0n1 # verify with lsblk! SATA disks are /dev/sdX
                         # and partitions are ${DISK}1 not ${DISK}p1

# GPT: 1 = ESP 1G, 2 = swap (e.g. 16G), 3 = rest for root
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart swap linux-swap 1GiB 17GiB
parted "$DISK" -- mkpart root 17GiB 100%

# LUKS on root and swap
cryptsetup luksFormat "${DISK}p3"
cryptsetup open "${DISK}p3" cryptroot
cryptsetup luksFormat "${DISK}p2"
cryptsetup open "${DISK}p2" cryptswap

# Filesystems
mkfs.fat -F32 -n BOOT "${DISK}p1"
mkswap /dev/mapper/cryptswap
mkfs.xfs -L nixos /dev/mapper/cryptroot

# Mount for install
mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount -o fmask=0077,dmask=0077 "${DISK}p1" /mnt/boot
swapon /dev/mapper/cryptswap
```

For an unencrypted host, skip the `cryptsetup` steps and run `mkfs.xfs` /
`mkswap` directly on the partitions.

## 3. Clone the repo onto the target

The repo is public, so cloning needs no key, read-only HTTPS is fine for the
install; switch the remote to SSH afterwards.

```bash
mkdir -p /mnt/home/$USER
cd /mnt/home/$USER
git clone https://github.com/cnsta/cnix.git
cd cnix
```

## 4. Regenerate hardware config and update the host

UUIDs (LUKS, filesystems, swap) are all new after a wipe, so the committed
`hardware-configuration.nix` is stale. Regenerate and overwrite:

```bash
nixos-generate-config --root /mnt --show-hardware-config \
  > hosts/$HOST/hardware-configuration.nix
```

## 5. Restore the host SSH key (agenix)

```bash
mkdir -p /mnt/etc/ssh
desktop$ scp ~/keys-$HOST/ssh_host_ed25519_key* nixos@<ip>:/tmp/
iso$ cp /tmp/ssh_host_ed25519_key* /mnt/etc/ssh/
iso$ chmod 600 /mnt/etc/ssh/ssh_host_ed25519_key
iso$ chmod 644 /mnt/etc/ssh/ssh_host_ed25519_key.pub
```

sshd will keep this key on first boot instead of generating a new one, and
agenix decryption (which uses the host key via `age.identityPaths` defaults)
works from the very first activation.

If you didn't save the key → **Appendix A**.

## 6. Install, with your Hydra cache

The ISO doesn't know about cache.cnst.dev, so pass it explicitly. This makes the
_install itself_ pull your Hydra-built closure instead of building or hitting
only cache.nixos.org:

```bash
nixos-install --flake /mnt/home/$USER/cnix#$HOST \
  --option extra-substituters "https://cache.cnst.dev" \
  --option extra-trusted-public-keys "cache.cnst.dev-1:3yhqzi3xAXkgMsnsxyZVuB23ynVtoZm/J9fI9omutqU="
```

Notes:

- Flake support is handled by `nixos-install` itself, no need to enable
  experimental features first. If your ISO is old and complains, prefix with
  `NIX_CONFIG="experimental-features = nix-command flakes"`.

## 6.5 Set user password

The config doesn't declare a password for `$USER` (`system/users.nix` has no
`hashedPassword`), and `users.mutableUsers` defaults to true, so passwords are
state in `/etc/shadow` and were lost in the wipe. Set them now, inside the
installed system, before rebooting:

```bash
nixos-enter --root /mnt -c "passwd $USER"
# optional but wise as a fallback:
nixos-enter --root /mnt -c "passwd root"
```

Skipping this leaves $USER with a locked password: SSH keys work, but console
login and sudo won't.

> Declarative alternative: add
> `users.users.$USER.hashedPasswordFile = config.age.secrets.userPwd.path;`
> (hash generated with `mkpasswd -m sha-512`, stored as an agenix secret). Then
> this step disappears and `--no-root-passwd` is fully hands-off.

## 7. First boot and cleanup

```bash
iso$ reboot
```

After booting into the full system:

```bash
# Fix ownership of the repo (it was cloned as root from the ISO)
sudo chown -R $USER:users ~/cnix

# Switch remote to SSH now that your user key/agent is available
cd ~/cnix && git remote set-url origin git@github.com:cnsta/cnix.git

# Commit the refreshed hardware config
git add hosts/$HOST/
git commit -m "$HOST: refresh hardware config after reinstall"
git push
```

Verify:

```bash
systemctl status          # degraded units?
ls -l /run/agenix/        # secrets decrypted?
nh os switch              # should be a no-op / trivial
```

Done. One install, first boot is the real system, first build came from Hydra.

---

## Appendix A: Rekeying agenix (lost/rotated host key)

If the old host key is gone, the new install can't decrypt secrets. On first
boot the machine generates a fresh host key; then, from any machine holding a
key already trusted in `secrets/keys.nix` (e.g. kima or your user key):

```bash
# Grab the new pubkey from the reinstalled host
scp $HOST:/etc/ssh/ssh_host_ed25519_key.pub hosts/$HOST/ssh_host_ed25519_key.pub

# Rekey all secrets against the updated recipient set
cd secrets && agenix --rekey

git commit -am "$HOST: new host key after reinstall" && git push
```

Then on the host: pull and `nh os switch`. Until this is done, anything
depending on agenix secrets (wifi passwords, tokens…) will fail on that host,
which is why step 0 exists.
