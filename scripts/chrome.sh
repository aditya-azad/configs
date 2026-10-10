#!/usr/bin/env bash
# Rewrite ~/.config/chromium/Default/Bookmarks from chrome/policies/managed/bookmarks.json
# (the ManagedBookmarks policy itself is Chrome-branded-only, unsupported by Arch chromium).
# NOTE: this replaces the bookmarks bar contents wholesale; close Chromium first.
set -euo pipefail
pgrep -x chromium >/dev/null && { echo "close Chromium first (or: pkill chromium)" >&2; exit 1; }
exec python3 - <<'EOF'
import json, os, time
now = str(int((time.time() + 11644473600) * 1e6)); ids = [0]
def conv(n):
    ids[0] += 1
    b = {"date_added": now, "date_modified": now, "id": str(ids[0]), "name": n["name"]}
    if "children" in n: b.update(type="folder", children=[conv(c) for c in n["children"]])
    else: b.update(type="url", url=n["url"])
    return b
kids = [conv(n) for n in json.load(open(os.path.expanduser("~/.config/chrome/policies/managed/bookmarks.json")))["policies"]["ManagedBookmarks"] if "name" in n]
p = os.path.expanduser("~/.config/chromium/Default/Bookmarks")
root = lambda i, name: {"children": [], "date_added": now, "date_modified": now, "id": str(i), "name": name, "type": "folder"}
json.dump({"roots": {"bookmark_bar": root(1, "Bookmarks bar") | {"children": kids},
                     "other": root(2, "Other bookmarks"), "synced": root(3, "Mobile bookmarks")},
           "version": 1}, open(p, "w"), indent=3)
print(f"wrote {len(kids)} entries to {p}")
EOF
