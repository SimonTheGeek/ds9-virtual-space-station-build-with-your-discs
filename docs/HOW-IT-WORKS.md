# How it works: problems and fixes

All of these were worked out on 2026-10-23. The Lingo was decompiled with [ProjectorRays](https://github.com/ProjectorRays/ProjectorRays) 0.2.0: its 64-bit Windows build, run under a separate win64 Wine prefix.

| # | Symptom | Cause | Fix (where) |
|---|---|---|---|
| 1 | "The application is not properly installed" | The program expects to have been installed by its Wise installer | Copy `disc7/application` to `C:\Program Files\DS9` and write the `HKCR\DS9appInstall` keys the installer would have set (`start-ds9.sh`, `reg/ds9app.reg`) |
| 2 | Hangs at first launch: online registration | With no registration code, it tries `http://www.ds9-virtualspacestation.com/connect_test.txt`, then `/php/register.php` (and `www.thomasevensen.org/ds9/regcode.php` for the questionnaire). Those sites are long gone | Not needed once fix #3 is in place: with a valid code, startup goes straight to the main screen with no network calls. `compose.yaml` still points those domains (and `riordanfaz.com`, where the main program fetches a news message, and falls back to the copy on the disc) at the container itself, so any stray call fails instantly and can't reach whoever owns those domains today |
| 3 | Asks for a registration code | `checkValidReg()` accepts **any** code except `0` or `00000000`. The code is stored in `HKCR\DS9appInstall\regcode` | `regcode=19920103` in `reg/ds9app.reg` |
| 4 | "Please insert disc DS9_7" | It checks drive D:'s volume label | Unpack the ISOs to folders under the Wine prefix. Give each a `.windows-label` file (`DS9_7`, `DS9`) and register the drives as plain disks, **not** CD-ROMs: Wine only reads `.windows-label` for non-CD drive types (`start-ds9.sh`) |
| 5 | Wine crashes (page fault) when the 3D view opens | `shockwave 3d asset.x32` uses DirectX 7. Wine's ddraw crashes in `d3d_device7_SetRenderTarget` → `validate_surface_palette` | Turn off ddraw for this exe only: `HKCU\Software\Wine\AppDefaults\virtual_space_station.exe\DllOverrides ddraw=""`. Shockwave 3D then falls back to OpenGL (Mesa) (`reg/appdefaults.reg`, renderer settings in `reg/macromedia.reg`) |
| 6 | Most seasons locked | Registry flags `season1`…`season7` record which discs you've "installed" | All set to `1`, plus `season_high=7` (`reg/ds9app.reg`) |
| 7 | Most items locked, 0% experience, Ensign rank | Each item has an unlock level. Your experience % for a season is the share of that season's items you have visited. Progress is saved in `C:\Program Files\DS9\Userdat.ini`, `[CurrentUser] disk1..disk7=[ids]` | `mkuserdat.py` reads the encyclopedia database and writes every item ID into the list for its season: 1,105 items, giving 120% and Captain rank. **The program rewrites this file when it quits**, so only write it while the program is closed |
| 8 | `mkuserdat.py` read the wrong number of records | Records in `db1_*.txt` end with a bare CR. Python's universal-newline mode splits them in the wrong places | `open(..., newline="")` and split on `\r` |

## Container layout
- **supervisord** runs these programs:
  - `xvfb` (:1, 1024×768×24)
  - `fluxbox`
  - `x11vnc` (localhost only)
  - `novnc` (websockify on :6080)
  - `ds9` (`start-ds9.sh`)
  - `pulseaudio`: a virtual sound card (`ds9` null sink). Wine's PulseAudio driver plays into it (`PULSE_SERVER=unix:/tmp/pulse.sock`)
  - `audiostream` (`audiostream.py`): serves MP3 on :6082, starting a fresh ffmpeg capture of the sink's monitor for each listener, so no stale audio builds up
  - the start page `ds9.html` (served as `/` by noVNC) shows noVNC full-screen, with a Sound button that plays the stream
- **Wine prefix** (`/root/.wine`, volume `ds9-wine`):
  - `cds/disc7` → D:
  - `cds/disc1` → E:
  - `C:\Program Files\DS9`
  - `ds9-setup.log`
  - `.ds9-setup-done`

## `bypass_firewallv1.exe` (discs 3–7, `images/`)
This is the publisher's own "patch v1.1", dated 2003-04-07: a small Director projector. It was examined statically and not run. It has no network code. It reads and writes `HKCR\DS9appInstall` (including `regcode`) so the program skips online registration for users behind a firewall. In other words, it is the official version of fix #3, and the container doesn't need it.

## Ideas not done yet
- A standalone encyclopedia: turn `db1_english.txt` and its images into a static website that works without the 3D program.
- Pull the screensaver and wallpapers out at full resolution.
