#!/bin/sh

COUNT=$(makoctl list | grep -c "id")
ENABLED=󰂚
DISABLED=󱏧
if [ "$COUNT" != 0 ]; then DISABLED="󱅫"; fi
if [ "$(
  makoctl mode | grep -q "default"
  echo $?
)" -eq 0 ]; then echo $ENABLED; else echo $DISABLED; fi
