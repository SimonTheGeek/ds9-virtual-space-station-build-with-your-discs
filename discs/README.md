# Put your disc images here

This repo contains **no disc content**. You need your own copies of the bonus CD-ROMs from the 2003 *Star Trek: Deep Space Nine* season DVD box sets.

| File | Needed | Why |
|---|---|---|
| `DS9_disc7.iso` | **Required** | Season 7 disc: the final program, the full encyclopedia (Seasons 1–7) and the `DS9_7` label the program checks for |
| `DS9_disc1.iso` | **Required** | Season 1 disc: the DS9 station 3D model and extra plug-ins, found only on this disc |
| `DS9_disc2.iso` … `DS9_disc6.iso` | Optional | Not used: everything on them is also on disc 7 |

## Making the images
- **Linux:** `scripts/image_disc.sh 7 /dev/sr0` (then put in disc 1 and run `scripts/image_disc.sh 1`).
- **Windows / macOS:** use any tool that saves a CD as a plain `.iso` (a 2048-byte-sector ISO 9660 image), then rename it to `DS9_disc7.iso` / `DS9_disc1.iso`.

## Checking them
`SHA256SUMS` lists the checksums of the UK (Region 2) discs this was built and tested with:

```bash
sha256sum -c SHA256SUMS --ignore-missing
```

A mismatch doesn't necessarily mean a bad image. Images made with a different tool, or discs from another region, can differ and still work.
