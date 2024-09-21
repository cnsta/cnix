#!/bin/sh

# Toggle Mako mode between "do-not-disturb" and "default"
if makoctl mode | grep -q "default"; then
    makoctl set-mode do-not-disturb
else
    makoctl set-mode default
fi
