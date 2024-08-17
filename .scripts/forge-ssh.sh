#!/usr/bin/env bash

# Get the original user's home directory and username
USER_HOME=$(eval echo ~${SUDO_USER:-$USER})
SSH_KEY="$USER_HOME/.ssh/id_ed25519"

MOUNT_POINT="$HOME/forge_mount"
REMOTE_SERVER="forge@167.172.100.32:/"

# Ensure SSH key has the correct permissions
if [ "$(stat -c %a "$SSH_KEY")" -ne 600 ]; then
	echo "Warning: SSH key permissions are not secure (expected 600)."
fi

# Create the mount point if it doesn't exist
mkdir -p "$MOUNT_POINT"

# Debugging: Print the SSHFS command before running it
echo "Running SSHFS with command:"
echo "sshfs -o IdentityFile=\"$SSH_KEY\" \"$REMOTE_SERVER\" \"$MOUNT_POINT\""

# Mount the remote server
if sshfs -o IdentityFile="$SSH_KEY" "$REMOTE_SERVER" "$MOUNT_POINT"; then
	echo "SSHFS mount successful."
else
	echo "SSHFS mount failed."
	exit 1
fi

# Check if the mount was successful
if ! mountpoint -q "$MOUNT_POINT"; then
	echo "Failed to mount $REMOTE_SERVER"
	exit 1
fi

echo "Successfully mounted $REMOTE_SERVER at $MOUNT_POINT"

# Change to the mounted directory
cd "$MOUNT_POINT" || {
	echo "Failed to navigate to $MOUNT_POINT"
	fusermount -u "$MOUNT_POINT"
	exit 1
}

# Keep the shell open to interact with the mounted directory
trap 'fusermount -u "$MOUNT_POINT"; exit' SIGINT SIGTERM
exec "${SHELL:-/bin/bash}"
