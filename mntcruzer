#!/usr/bin/env bash

UUIDS=(
    "796cbd8a-b6e5-4c20-b6a5-04a471d3a64d" # cruzer1
    "25d63b4d-4a03-4160-896d-b7be71e257e8" # cruzer2
    "bf241007-9646-400a-867a-7b4fa1748e6f" # cruzer3
);

# check $1 is valid else lock all
if [[ $1 -gt ${#UUIDS[@]} ]] || [[ $1 -lt 1 ]]; then
    echo "Invalid UUID, locking all";
    for n in ${UUIDS[@]}; do
        echo -e "\nChecking $n...";
        if [[ -e /dev/mapper/luks-$n ]]; then
            echo "Unmounting..."
            udisksctl unmount -f -b /dev/mapper/luks-$n
        fi;
        if [[ -e /dev/disk/by-uuid/$n ]]; then
            echo "Locking..."
            udisksctl lock -b /dev/disk/by-uuid/$n
        fi
        echo "Done";
    done;
    exit 1
fi

# unlock device and mount it
echo "Unlocking: cruzer$1 (${UUIDS[$1-1]})"
udisksctl unlock -b /dev/disk/by-uuid/${UUIDS[$1-1]}
echo "Mounting: cruzer$1 (${UUIDS[$1-1]})"
udisksctl mount -b /dev/mapper/luks-${UUIDS[$1-1]}
