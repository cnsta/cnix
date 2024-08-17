#!/bin/bash

# Script to clean up old initrd and kernel files in /boot/EFI/nixos
# Make sure it's added to flake.nix, then run:
# "nix build .#packages.x86_64-linux.cleanup-boot".

# Number of generations to keep
KEEP_GENERATIONS=4

# Log file for cleanup actions
LOG_FILE="/var/log/cleanup-boot.log"

# Dry run flag
DRY_RUN=false

# Check for dry run argument
if [ "$1" = "--dry-run" ]; then
	DRY_RUN=true
fi

# Function to log messages
log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Exit on any error
set -e

log "Starting cleanup script. Keeping the latest $KEEP_GENERATIONS generations."

# List the initrd files in /boot/EFI/nixos sorted by modification time (oldest first)
mapfile -t initrd_files < <(find /boot/EFI/nixos -type f -name '*initrd*.efi' -printf '%T@ %p\n' | sort -n)

# List the kernel files in /boot/EFI/nixos sorted by modification time (oldest first)
mapfile -t kernel_files < <(find /boot/EFI/nixos -type f -name '*kernel*.efi' -printf '%T@ %p\n' | sort -n)

# Count the number of initrd and kernel files
initrd_count=${#initrd_files[@]}
kernel_count=${#kernel_files[@]}

log "Found $initrd_count initrd files and $kernel_count kernel files."

# Initialize arrays to hold files to delete
delete_initrd_files=()
delete_kernel_files=()

# If there are fewer than KEEP_GENERATIONS initrd files, don't delete any
if [ "$initrd_count" -le "$KEEP_GENERATIONS" ]; then
	log "Fewer than $KEEP_GENERATIONS initrd files found. No initrd files will be deleted."
else
	# Get the initrd files to delete
	delete_initrd_files=("${initrd_files[@]:0:initrd_count-KEEP_GENERATIONS}")
fi

# If there are fewer than KEEP_GENERATIONS kernel files, don't delete any
if [ "$kernel_count" -le "$KEEP_GENERATIONS" ]; then
	log "Fewer than $KEEP_GENERATIONS kernel files found. No kernel files will be deleted."
else
	# Get the kernel files to delete
	delete_kernel_files=("${kernel_files[@]:0:kernel_count-KEEP_GENERATIONS}")
fi

# Log the files identified for deletion
log "Files identified for deletion:"
for file_entry in "${delete_initrd_files[@]}" "${delete_kernel_files[@]}"; do
	file=$(echo "$file_entry" | cut -d' ' -f2-)
	log "$file"
done

# Confirm dry run mode
if [ "$DRY_RUN" = true ]; then
	log "Dry run mode enabled. No files will be deleted."
fi

# Remove old files
for file_entry in "${delete_initrd_files[@]}" "${delete_kernel_files[@]}"; do
	file=$(echo "$file_entry" | cut -d' ' -f2-)
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
