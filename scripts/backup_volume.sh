#!/bin/bash
# Back up / restore the Wine volume (install, registry, progress in Userdat.ini).
# usage: scripts/backup_volume.sh backup [file.tgz]   |   scripts/backup_volume.sh restore file.tgz
set -euo pipefail
VOL=${VOL:-$(docker inspect -f '{{range .Mounts}}{{if eq .Destination "/root/.wine"}}{{.Name}}{{end}}{{end}}' ds9-vss)}
case "${1:-}" in
  backup)  F=${2:-ds9-wine-$(date +%F).tgz}; docker stop ds9-vss >/dev/null
           docker run --rm -v "$VOL":/v -v "$PWD":/b debian:bookworm-slim tar czf "/b/$(basename "$F")" -C /v .
           docker start ds9-vss >/dev/null; echo "saved $F" ;;
  restore) F=${2:?file.tgz}; docker stop ds9-vss >/dev/null 2>&1 || true
           docker run --rm -v "$VOL":/v -v "$(cd "$(dirname "$F")" && pwd)":/b debian:bookworm-slim \
             sh -c "rm -rf /v/* /v/.[!.]* 2>/dev/null; tar xzf /b/$(basename "$F") -C /v"
           docker start ds9-vss >/dev/null 2>&1 || true; echo "restored $F" ;;
  *) echo "usage: $0 backup [file.tgz] | restore file.tgz"; exit 1 ;;
esac
