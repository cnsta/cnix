# Pulls a list of container images with podman and reports which ones
# received a new version (image ID changed after the pull).

IMAGES=(
  ghcr.io/haveagitgat/tdarr:latest
  ghcr.io/kfalabs/tdarr-battlemage:latest
  docker.io/pihole/pihole:latest
  ghcr.io/hotio/qbittorrent:latest
  ghcr.io/hotio/radarr:latest
  ghcr.io/hotio/sonarr:latest
  ghcr.io/hotio/lidarr:latest
  ghcr.io/hotio/prowlarr:latest
  ghcr.io/hotio/sabnzbd:latest
  ghcr.io/hotio/jellyfin:latest
  docker.io/flaresolverr/flaresolverr:latest
  docker.io/deluan/navidrome:latest
  docker.io/homeassistant/home-assistant:stable
  ghcr.io/tale/headplane:latest
  ghcr.io/v1ck3s/octo-fiesta:dev
  ghcr.io/qdm12/gluetun:latest
  docker.io/miniflux/miniflux:latest
)

if [[ $EUID -ne 0 ]]; then
  exec sudo "$0" "$@"
fi

updated=()
unchanged=()
failed=()

for image in "${IMAGES[@]}"; do
  echo "==> Pulling $image"

  before=$(podman image inspect --format '{{.Id}}' "$image" 2>/dev/null || echo "none")

  if ! podman pull --quiet "$image"; then
    failed+=("$image")
    echo
    continue
  fi

  after=$(podman image inspect --format '{{.Id}}' "$image" 2>/dev/null || echo "error")

  if [[ "$before" == "none" ]]; then
    updated+=("$image (newly downloaded)")
  elif [[ "$before" != "$after" ]]; then
    updated+=("$image")
  else
    unchanged+=("$image")
  fi
  echo
done

echo "=============================================="
echo " Summary"
echo "=============================================="

if ((${#updated[@]})); then
  echo
  echo "Updated (${#updated[@]}):"
  printf '  %s\n' "${updated[@]}"
fi

if ((${#unchanged[@]})); then
  echo
  echo "Already up to date (${#unchanged[@]}):"
  printf '  %s\n' "${unchanged[@]}"
fi

if ((${#failed[@]})); then
  echo
  echo "FAILED to pull (${#failed[@]}):"
  printf '  %s\n' "${failed[@]}"
fi

echo
if ((${#updated[@]})); then
  echo "Note: running containers keep using the old image until you"
  echo "recreate/restart them (e.g. podman restart, or re-run your"
  echo "podman run / systemd unit / compose setup)."
fi

if ((${#failed[@]})); then
  exit 1
fi
