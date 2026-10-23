#!/bin/bash
# First run: build the Wine prefix and "install" the Virtual Space Station exactly as the Wise installer + our fixes did.
# Later runs: just launch it. Disc images are expected at /discs/DS9_disc1.iso and /discs/DS9_disc7.iso (all 7 may be present).
set -u
W=$WINEPREFIX; APP="$W/drive_c/Program Files/DS9"; LOG=/root/.wine/ds9-setup.log
sleep 4
if [ ! -f "$W/.ds9-setup-done" ]; then
  exec > >(tee -a "$LOG") 2>&1
  echo "[ds9] first-run setup $(date)"
  for n in 7 1; do
    if [ ! -f "/discs/DS9_disc$n.iso" ]; then
      echo "[ds9] ERROR: /discs/DS9_disc$n.iso not found. Put your own disc images in ./discs (see discs/README.md), then: docker compose restart"
      sleep infinity
    fi
  done
  wineboot -i; wineserver -w
  # 1. Discs: unpack disc 7 (full content) and disc 1 (station model) into writable folders labelled like the real CDs.
  #    Wine reads a folder drive's label from .windows-label, but only when the drive is NOT typed as cdrom.
  mkdir -p "$W/cds"
  for n in 7 1; do
    d="$W/cds/disc$n"; rm -rf "$d"; mkdir -p "$d"
    bsdtar -xf "/discs/DS9_disc$n.iso" -C "$d" && chmod -R u+w "$d"
    [ $n = 1 ] && printf DS9 > "$d/.windows-label" || printf "DS9_$n" > "$d/.windows-label"
  done
  ln -sfn "$W/cds/disc7" "$W/dosdevices/d:"; ln -sfn "$W/cds/disc1" "$W/dosdevices/e:"
  # 2. Install: the Wise installer just copies the application folder and writes registry keys.
  mkdir -p "$APP"; cp -a "$W/cds/disc7/application/." "$APP/"
  # 3. Registry: install keys (all 7 seasons, region UK, english, any regcode != 0 counts as registered),
  #    Shockwave settings, and ddraw disabled for this exe (DirectX 7 path crashes in Wine; OpenGL works).
  for r in ds9app macromedia appdefaults; do wine regedit /S "Z:\\opt\\ds9\\reg\\$r.reg"; done
  # 4. Everything unlocked: mark every encyclopedia item as visited (experience shows ~120%, which is fine).
  if [ "${UNLOCK_ALL:-1}" = 1 ]; then
    python3 /opt/ds9/mkuserdat.py "$W/cds/disc7/db1_english.txt" "$APP/Userdat.ini"
  else
    echo "[ds9] UNLOCK_ALL=0: starting with no progress (items unlock as you explore)"
  fi
  wineserver -w; touch "$W/.ds9-setup-done"; echo "[ds9] setup done"
fi
cd "$APP" && exec wine virtual_space_station.exe
