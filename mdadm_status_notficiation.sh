#!/usr/bin/env sh
# This script is called by the mdadm daemon which itself is run as system service:
# monitor --scan --daemonise --program=/path/to/script.sh

# Get RAID status
raid_status=$(mdadm --detail /dev/md${MDADM_DEVICE#/dev/md} | grep State)

# Send notification
DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "RAID event detected on $MDADM_DEVICE" "Event: $MDADM_EVENT\nRAID level: $MDADM_LEVEL\nDevices: $MDADM_RAID_DEVICES\nStatus: $raid_status"
