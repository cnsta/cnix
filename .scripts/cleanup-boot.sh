#!/usr/bin/env bash

# Script to clean up old initrd and kernel files in /boot/EFI/nixos
# Make sure it's added to flake.nix, then run:
# "nix build .#packages.x86_64-linux.cleanup-boot".

# Exit on any error, undefined variable, or pipeline failure
set -euo pipefail

# Default number of kernel and initrd files to keep
KEEP_KERNEL=4
KEEP_INITRD=6

# Log file for cleanup actions
LOG_FILE="/var/log/cleanup-boot.log"

# Dry run flag
DRY_RUN=false

# Function to display usage information
usage() {
  echo "Usage: $0 [--dry-run] [--keep-kernel N] [--keep-initrd N] [--help]"
  echo
  echo "Options:"
  echo "  --dry-run         Perform a trial run with no changes made."
  echo "  --keep-kernel N   Keep the latest N kernel files (default: 4)."
  echo "  --keep-initrd N   Keep the latest N initrd files (default: 6)."
  echo "  --help, -h        Show this help message."
  exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
  --dry-run)
    DRY_RUN=true
    ;;
  --keep-kernel)
    if [[ -n "${2:-}" && "$2" =~ ^[1-9][0-9]*$ ]]; then
      KEEP_KERNEL="$2"
      shift
    else
      echo "Error: --keep-kernel requires a positive integer."
      usage
    fi
    ;;
  --keep-initrd)
    if [[ -n "${2:-}" && "$2" =~ ^[1-9][0-9]*$ ]]; then
      KEEP_INITRD="$2"
      shift
    else
      echo "Error: --keep-initrd requires a positive integer."
      usage
    fi
    ;;
  --help | -h)
    usage
    ;;
  *)
    echo "Unknown option: $1"
    usage
    ;;
  esac
  shift
done

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root."
  exit 1
fi

# Check if log file is writable
if ! touch "$LOG_FILE" &>/dev/null; then
  echo "Error: Cannot write to log file $LOG_FILE"
  exit 1
fi

# Function to log messages with timestamps
log() {
  local message
  message="$(date '+%Y-%m-%d %H:%M:%S') - $1"
  echo "$message" | tee -a "$LOG_FILE"
  logger -t cleanup-boot "$message"
}

log "Starting cleanup script. Keeping $KEEP_KERNEL kernel files and $KEEP_INITRD initrd files."

# Collect all .efi files in /boot/EFI/nixos
mapfile -d '' -t efi_files < <(find /boot/EFI/nixos -type f -name '*.efi' -print0)

# Initialize arrays for kernel and initrd files
kernel_files=()
initrd_files=()

# Parse filenames and collect kernel and initrd files based on patterns
for file in "${efi_files[@]}"; do
  basename=$(basename "$file")

  # Pattern: <hash>-linux-<version>-bzImage.efi (kernel)
  if [[ "$basename" =~ ^(.*)-linux-([0-9]+\.[0-9]+(\.[0-9]+)?)\-bzImage\.efi$ ]]; then
    kernel_files+=("$file")

  # Pattern: <hash>-initrd-linux-<version>-initrd.efi (initrd)
  elif [[ "$basename" =~ ^(.*)-initrd-linux-([0-9]+\.[0-9]+(\.[0-9]+)?)\-initrd\.efi$ ]]; then
    initrd_files+=("$file")

  # Pattern: kernel-<version>-<hash>.efi (kernel)
  elif [[ "$basename" =~ ^kernel-([0-9]+\.[0-9]+(\.[0-9]+)?)\-([a-zA-Z0-9\-]+)\.efi$ ]]; then
    kernel_files+=("$file")

  # Pattern: initrd-<version>-<hash>.efi (initrd)
  elif [[ "$basename" =~ ^initrd-([0-9]+\.[0-9]+(\.[0-9]+)?)\-([a-zA-Z0-9\-]+)\.efi$ ]]; then
    initrd_files+=("$file")

  else
    log "Warning: Unrecognized filename format: $basename"
    continue
  fi
done

# Function to process and delete old files
process_files() {
  local -n files=$1 # Pass array by reference
  local keep_count=$2
  local file_type=$3

  log "Processing $file_type files..."

  if [ "${#files[@]}" -gt "$keep_count" ]; then
    # Sort files by modification time (newest first)
    sorted_files=$(for f in "${files[@]}"; do echo "$(stat -c '%Y' "$f"):$f"; done | sort -rn -k1,1)

    # Collect files to delete (older than the top N)
    mapfile -t files_to_delete < <(echo "$sorted_files" | tail -n +"$((keep_count + 1))" | cut -d: -f2)

    for file in "${files_to_delete[@]}"; do
      log "Deleting $file"
      if [ "$DRY_RUN" = false ]; then
        rm -f -- "$file"
      else
        log "Dry run - would delete: $file"
      fi
    done
  else
    log "No $file_type files to delete. Current count: ${#files[@]}"
  fi
}

# Process kernel and initrd files
process_files kernel_files "$KEEP_KERNEL" "kernel"
process_files initrd_files "$KEEP_INITRD" "initrd"

log "Cleanup script completed."
