#!/bin/bash
# Image one DS9 CD-ROM to discs/DS9_discN.iso.
# usage: scripts/image_disc.sh N [device]      (device defaults to /dev/sr0)
set -euo pipefail
N=${1:?disc number 1-7}; DEV=${2:-/dev/sr0}
OUT="$(dirname "$0")/../discs/DS9_disc$N.iso"
for i in $(seq 1 45); do blkid "$DEV" >/dev/null 2>&1 && break; sleep 2; done
blkid "$DEV"
SZ=$(isosize "$DEV"); echo "size $((SZ/1048576)) MB"
dd if="$DEV" of="$OUT" bs=2048 count=$((SZ/2048)) conv=noerror,sync status=progress
sha256sum "$OUT"
