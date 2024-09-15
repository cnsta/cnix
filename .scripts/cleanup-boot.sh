#!/usr/bin/env bash

# Script to clean up old initrd and kernel files in /boot/EFI/nixos

# Exit on any error, undefined variable, or pipeline failure
set -euo pipefail

# Ensure Bash 4 or newer is being used
if ((BASH_VERSINFO[0] < 4)); then
  echo "Error: This script requires Bash version 4 or higher."
  exit 1
fi

# Default number of versions and files to keep
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
  echo
  echo "Examples:"
  echo "  ./cleanup-boot.sh --dry-run"
  echo "  ./cleanup-boot.sh --keep-kernel 3 --keep-initrd 5"
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

declare -A kernels_files_by_version
declare -A initrds_files_by_version
declare -A versions_mtime

# Parse filenames to group kernel and initrd files by their version number
for file in "${efi_files[@]}"; do
  basename=$(basename "$file")

  # Pattern 1: <hash>-linux-<version>-bzImage.efi (kernel)
  if [[ "$basename" =~ ^(.*)-linux-([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9\.\+]+)?)-bzImage\.efi$ ]]; then
    version="${BASH_REMATCH[2]}"
    type="kernel"

  # Pattern 1: <hash>-initrd-linux-<version>-initrd.efi (initrd)
  elif [[ "$basename" =~ ^(.*)-initrd-linux-([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9\.\+]+)?)-initrd\.efi$ ]]; then
    version="${BASH_REMATCH[2]}"
    type="initrd"

  # Pattern 2: kernel-<version>-<hash>.efi (kernel)
  elif [[ "$basename" =~ ^kernel-([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9\.\+]+)?)-([a-zA-Z0-9]+)\.efi$ ]]; then
    version="${BASH_REMATCH[1]}"
    type="kernel"

  # Pattern 2: initrd-<version>-<hash>.efi (initrd)
  elif [[ "$basename" =~ ^initrd-([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9\.\+]+)?)-([a-zA-Z0-9]+)\.efi$ ]]; then
    version="${BASH_REMATCH[1]}"
    type="initrd"

  else
    log "Warning: Unrecognized filename format: $basename"
    continue
  fi

  # Get file modification time
  if ! file_mtime=$(stat -c '%Y' "$file" 2>/dev/null); then
    log "Warning: Failed to get modification time for $file"
    continue
  fi

  # Append the file to the list of files per version and type
  entry="$file_mtime|$file"
  if [[ "$type" == "kernel" ]]; then
    kernels_files_by_version["$version"]+="$entry"$'\n'
  elif [[ "$type" == "initrd" ]]; then
    initrds_files_by_version["$version"]+="$entry"$'\n'
  fi

  # Update the latest modification time for the version
  version_mtime="${versions_mtime["$version"]:-0}"
  if [[ "$file_mtime" -gt "$version_mtime" ]]; then
    versions_mtime["$version"]="$file_mtime"
  fi
done

# Collect all versions
all_versions=("${!versions_mtime[@]}")

# Sort versions by their latest modification time (newest first)
mapfile -t sorted_versions < <(
  for version in "${all_versions[@]}"; do
    echo "${versions_mtime[$version]}:$version"
  done | sort -rn -k1,1 | awk -F: '{print $2}'
)

version_count=${#sorted_versions[@]}

log "Found $version_count versions."

if [ "$version_count" -eq 0 ]; then
  log "No versions found."
  exit 0
fi

# Initialize delete_files array
delete_files=()

# Log the files identified for deletion
log "Files identified for deletion:"

# Process initrd files
for version in "${sorted_versions[@]}"; do
  initrd_files="${initrds_files_by_version["$version"]:-}"

  if [ -n "$initrd_files" ]; then
    IFS=''
    mapfile -t initrd_files_array <<<"$initrd_files"
    unset IFS
    # Sort initrd files by mtime and filename (newest first)
    mapfile -t sorted_initrd_files < <(printf '%s\n' "${initrd_files_array[@]}" | sort -rn -k1,1 -k2,2)
    initrd_file_count=${#sorted_initrd_files[@]}
    if [ "$KEEP_INITRD" -gt 0 ] && [ "$initrd_file_count" -gt "$KEEP_INITRD" ]; then
      files_to_delete=("${sorted_initrd_files[@]:$KEEP_INITRD}")
      for entry in "${files_to_delete[@]}"; do
        file="${entry#*|}"
        delete_files+=("$file")
        log "$file"
      done
    fi
  fi
done

# Process kernel files
for version in "${sorted_versions[@]}"; do
  kernel_files="${kernels_files_by_version["$version"]:-}"

  if [ -n "$kernel_files" ]; then
    IFS=''
    mapfile -t kernel_files_array <<<"$kernel_files"
    unset IFS
    # Sort kernel files by mtime and filename (newest first)
    mapfile -t sorted_kernel_files < <(printf '%s\n' "${kernel_files_array[@]}" | sort -rn -k1,1 -k2,2)
    kernel_file_count=${#sorted_kernel_files[@]}
    if [ "$KEEP_KERNEL" -gt 0 ] && [ "$kernel_file_count" -gt "$KEEP_KERNEL" ]; then
      files_to_delete=("${sorted_kernel_files[@]:$KEEP_KERNEL}")
      for entry in "${files_to_delete[@]}"; do
        file="${entry#*|}"
        delete_files+=("$file")
        log "$file"
      done
    fi
  fi
done

if [ ${#delete_files[@]} -eq 0 ]; then
  log "No files to delete."
  exit 0
fi

# Confirm dry run mode
if [ "$DRY_RUN" = true ]; then
  log "Dry run mode enabled. No files will be deleted."
fi

# Remove old files
for file in "${delete_files[@]}"; do
  # Skip empty entries
  if [[ -z "$file" ]]; then
    continue
  fi

  # Resolve absolute path
  resolved_file=$(realpath "$file")

  # Security check: Ensure the file is within /boot/EFI/nixos
  if [[ "$resolved_file" != /boot/EFI/nixos/* ]]; then
    log "Warning: Attempted to delete file outside of /boot/EFI/nixos: $resolved_file"
    continue
  fi

  if [ "$DRY_RUN" = false ]; then
    if rm -f -- "$resolved_file"; then
      log "Deleted: $resolved_file"
    else
      log "Failed to delete: $resolved_file"
    fi
  else
    log "Dry run - would delete: $resolved_file"
  fi
done

log "Cleanup script completed."
