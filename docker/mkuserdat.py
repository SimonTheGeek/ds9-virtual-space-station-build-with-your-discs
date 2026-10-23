# Usage: mkuserdat.py <db1_english.txt> <Userdat.ini>  - writes a progress file with every item visited (unlocks all).
import collections, sys
d = open(sys.argv[1], encoding="latin-1", newline="").read()   # records are separated by CR only
rows = d.split("\r"); isea = rows[0].split("\t").index("itemSeason")
by = collections.defaultdict(set)
for r in rows[1:]:
    f = r.split("\t")
    if len(f) > isea and f[0].strip().isdigit() and f[isea].strip().isdigit(): by[int(f[isea])].add(int(f[0]))
lines = ["[CurrentUser]"] + [f"disk{s}=[{', '.join(str(x) for x in sorted(by[s]))}]" for s in range(1, 8)]
open(sys.argv[2], "w", newline="\r\n").write("\n".join(lines) + "\n")
print("Userdat.ini:", {s: len(by[s]) for s in range(1, 8)})
