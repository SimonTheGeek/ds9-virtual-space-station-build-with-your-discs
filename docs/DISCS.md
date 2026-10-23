# Disc inventory

Each 2003 *Star Trek: Deep Space Nine* season DVD box set (Region 2, UK) came with one bonus CD-ROM. All seven were imaged on 2026-10-23.

| Disc | Box set | Volume label | Date on disc | Size | Encyclopedia | Images / models | Files that differ from the previous disc |
|---|---|---|---|---|---|---|---|
| 1 | Season 1 | `DS9` | 2003-02-06 | 43 MB | none | 1 / 1 | 107 files, all new: the program, installer (Wise `setup.exe`, `endak.exe`), screensaver `DS9.scr`, station model `Star trek DS9 Station.w3d`, extra Xtras (EasyBase, OPENDBC, TreeView, image import/export) |
| 2 | Season 2 | `DS9_2` | 2003-03-17 | 46 MB | S1–S2, 371 entries | 132 / 10 | 148 new (`db1_*.txt` in 6 languages + 141 images), 19 changed (program casts, `main.dxr`); drops the station model and some Xtras |
| 3 | Season 3 | `DS9_3` | 2003-05-08 | 54 MB | S1–S3, 528 | 207 / 10 | 77 new images (incl. `images/bypass_firewallv1.exe`), 24 changed (databases, casts) |
| 4 | Season 4 | `DS9_4` | 2003-06-26 | 78 MB | **S1–S7, 1,105** | 444 / 26 | 253 new images/models, 27 changed: the complete encyclopedia |
| 5 | Season 5 | `DS9_5` | 2003-06-26 | 78 MB | S1–S7, 1,105 | 444 / 26 | **nothing new**: only `setup.exe` and `endak.exe` differ |
| 6 | Season 6 | `DS9_6` | 2003-06-26 | 78 MB | S1–S7, 1,105 | 444 / 26 | **nothing new**: only `setup.exe` and `endak.exe` differ |
| 7 | Season 7 | `DS9_7` | 2003-06-26 | 78 MB | S1–S7, 1,105 | 444 / 26 | `setup.exe`, `endak.exe` and an updated `application/init.dxr` |

The installers differ between discs because each one marks its own season as installed (the `seasonN` registry flags).

Entries per season (from disc 4 onwards): S1 180, S2 191, S3 157, S4 161, S5 155, S6 148, S7 113.

The container uses **disc 7** as drive D: (the newest `init.dxr`, the full database, and the `DS9_7` label the program checks for) and **disc 1** as drive E: (the station model and extra Xtras are only on disc 1).

## Formats
- Engine: Macromedia Director 8.5 projector (`virtual_space_station.exe`, `init.dxr`, `main.dxr`, `*.cxt` casts) with Xtras for Shockwave 3D, Net Support, FileXtra3, Buddy API, DirectMedia, ActiveX, EasyBase/OPENDBC and TreeView.
- Encyclopedia: `db1_<language>.txt`, in 6 languages. Fields are separated by tabs and **records by a bare CR**. Fields: itemId, itemName, topicID, topicName, itemSeason, rank, itemLinks, itemText (HTML), itemImages, itemModel, and more.
- Images: `images/NNNN_k.bmp`, keyed by item ID. 3D models: `images/modNNNN_1.w3d`.

## Checksums
See `discs/SHA256SUMS`. To check them:

```bash
cd discs && sha256sum -c SHA256SUMS
```
