#!/bin/bash

# Script to clean up old initrd and kernel files in /boot/EFI/nixos
#
# Build the script with:
#   nix build .#packages.x86_64-linux.cleanup-boot
# Run the script with:
#   nix run .#cleanup-boot -- --dry-run
# The '--' is required to pass arguments to the script.
#
# This script keeps the latest N kernel/initrd pairs (entries).
# Each entry consists of a kernel and an initrd file identified by the same version number.

# Default number of entries to keep
KEEP_ENTRIES=4

# Log file for cleanup actions
LOG_FILE="/var/log/cleanup-boot.log"

# Dry run flag
DRY_RUN=false

# Include incomplete entries flag
INCLUDE_INCOMPLETE=false

# Function to display usage information
usage() {
  echo "Usage: $0 [--dry-run] [--keep N] [--include-incomplete] [--help]"
  echo
  echo "Note: When running with 'nix run', use '--' before script arguments."
  echo
  echo "Options:"
  echo "  --dry-run             Perform a trial run with no changes made."
  echo "  --keep N              Keep the latest N kernel/initrd pairs (default: 4)."
  echo "  --include-incomplete  Include incomplete entries in deletion."
  echo "  --help, -h            Show this help message."
  echo
  echo "Examples:"
  echo "  nix run .#cleanup-boot -- --dry-run"
  echo "  ./result --keep 5"
  exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
  --dry-run)
    DRY_RUN=true
    ;;
  --keep)
    if [[ -n "${2:-}" && "$2" =~ ^[0-9]+$ ]]; then
      KEEP_ENTRIES="$2"
      shift
    else
      echo "Error: --keep requires a numeric argument."
      usage
    fi
    ;;
  --include-incomplete)
    INCLUDE_INCOMPLETE=true
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

# Exit on any error, undefined variable, or pipeline failure
set -euo pipefail

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
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Starting cleanup script. Keeping the latest $KEEP_ENTRIES kernel/initrd pairs."

# Collect all .efi files in /boot/EFI/nixos
mapfile -t efi_files < <(find /boot/EFI/nixos -type f -name '*.efi')

declare -A entries

# Parse filenames to group kernel and initrd files by their version number
for file in "${efi_files[@]}"; do
  basename=$(basename "$file")
  # Extract the version number
  if [[ "$basename" =~ ^(initrd|kernel)-(.*)-(.*)\.efi$ ]]; then
    type="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[2]}"
    # hash="${BASH_REMATCH[3]}"  # Removed unused variable
  elif [[ "$basename" =~ ^(.*)-(.*)-(initrd|kernel)\.efi$ ]]; then
    # hash="${BASH_REMATCH[1]}"  # Removed unused variable
    version="${BASH_REMATCH[2]}"
    type="${BASH_REMATCH[3]}"
  else
    log "Warning: Unrecognized filename format: $basename"
    continue
  fi

  key="$version"
  entries["$key,$type"]="$file"

  # Store the earliest modification time among kernel and initrd
  file_mtime=$(stat -c '%Y' "$file")
  existing_mtime="${entries["$key,mtime"]:-}"
  if [[ -z "$existing_mtime" ]] || [[ "$file_mtime" -lt "$existing_mtime" ]]; then
    entries["$key,mtime"]="$file_mtime"
  fi
done

# Decide whether to include incomplete entries
declare -A valid_entries

if [ "$INCLUDE_INCOMPLETE" = true ]; then
  # Include all entries
  for key in "${!entries[@]}"; do
    if [[ "$key" =~ ,mtime$ ]]; then
      version="${key%,mtime}"
      valid_entries["$version,initrd"]="${entries["$version,initrd"]:-}"
      valid_entries["$version,kernel"]="${entries["$version,kernel"]:-}"
      valid_entries["$version,mtime"]="${entries["$version,mtime"]}"
    fi
  done
else
  # Include only complete entries
  for key in "${!entries[@]}"; do
    if [[ "$key" =~ ,mtime$ ]]; then
      version="${key%,mtime}"
      if [[ -n "${entries["$version,initrd"]:-}" && -n "${entries["$version,kernel"]:-}" ]]; then
        valid_entries["$version,initrd"]="${entries["$version,initrd"]}"
        valid_entries["$version,kernel"]="${entries["$version,kernel"]}"
        valid_entries["$version,mtime"]="${entries["$version,mtime"]}"
      else
        log "Warning: Incomplete entry detected for version $version."
      fi
    fi
  done
fi

# Sort the entries by modification time (newest first)
mapfile -t sorted_entries < <(
  for key in "${!valid_entries[@]}"; do
    if [[ "$key" =~ ,mtime$ ]]; then
      version="${key%,mtime}"
      mtime="${valid_entries[$key]}"
      echo "$mtime:$version"
    fi
  done | sort -rn | awk -F: '{print $2}'
)

# Remove duplicates
unique_versions=()
declare -A seen_versions
for version in "${sorted_entries[@]}"; do
  if [[ -z "${seen_versions[$version]:-}" ]]; then
    unique_versions+=("$version")
    seen_versions["$version"]=1
  fi
done

entry_count=${#unique_versions[@]}

log "Found $entry_count kernel/initrd pairs."

if [ "$entry_count" -le "$KEEP_ENTRIES" ]; then
  log "Fewer than or equal to $KEEP_ENTRIES pairs found. No files will be deleted."
  exit 0
fi

# Determine entries to delete
entries_to_delete=("${unique_versions[@]:$KEEP_ENTRIES}")

# Log the files identified for deletion
log "Files identified for deletion:"
delete_files=()
for version in "${entries_to_delete[@]}"; do
  initrd_file="${valid_entries["$version,initrd"]:-}"
  kernel_file="${valid_entries["$version,kernel"]:-}"

  if [ -n "$initrd_file" ]; then
    delete_files+=("$initrd_file")
    log "$initrd_file"
  fi
  if [ -n "$kernel_file" ]; then
    delete_files+=("$kernel_file")
    log "$kernel_file"
  fi
done

# Confirm dry run mode
if [ "$DRY_RUN" = true ]; then
  log "Dry run mode enabled. No files will be deleted."
fi

# Remove old files
for file in "${delete_files[@]}"; do
  # Security check: Ensure the file is within /boot/EFI/nixos
  if [[ "$file" != /boot/EFI/nixos/* ]]; then
    log "Warning: Attempted to delete file outside of /boot/EFI/nixos: $file"
    continue
  fi

  if [ "$DRY_RUN" = false ]; then
    if rm -f "$file"; then
      log "Deleted: $file"
    else
      log "Failed to delete: $file"
    fi
  else
    log "Dry run - would delete: $file"
  fi
done

log "Cleanup script completed."
