#!/bin/sh
export PATH="/etc/profiles/per-user/cnst/bin:$PATH"
echo "PATH=$PATH" > /tmp/tsserver-log.txt
exec /etc/profiles/per-user/cnst/bin/tsserver "$@" >> /tmp/tsserver-log.txt 2>&1
