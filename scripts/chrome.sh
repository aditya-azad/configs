#!/usr/bin/env bash
# Install bookmarks into Chromium by writing the profile's Bookmarks file
# directly. (ManagedBookmarks policy is NOT supported by the Chromium build
# — it is Chrome-branded-only — so the policy approach is replaced with a
# profile merge. Chromium must be closed while we edit the profile.)
#
# Usage: chrome.sh [--kill]     --kill: close running Chromium automatically
set -euo pipefail

PROFILE="$HOME/.config/chromium/Default"
BOOKMARKS="$PROFILE/Bookmarks"

if pgrep -x chromium >/dev/null || pgrep -f "/usr/lib/chromium/chromium" >/dev/null; then
  if [[ "${1:-}" == "--kill" ]]; then
    pkill chromium || true
    for _ in $(seq 1 20); do pgrep chromium >/dev/null || break; sleep 0.5; done
    pgrep chromium >/dev/null && { echo "chromium did not exit" >&2; exit 1; }
  else
    echo "chromium is running. close it fully, or run: $0 --kill" >&2
    exit 1
  fi
fi

# Remove the policy file Chromium reports as "Unknown policy" (harmless but noisy).
sudo rm -f /etc/chromium/policies/managed/bookmarks.json \
           /etc/opt/chrome/policies/managed/bookmarks.json

python3 - "$BOOKMARKS" <<'PYEOF'
import json, os, sys, time

path = sys.argv[1]
urls = [
    ("OpenRouter",  "https://openrouter.ai/settings/credits"),
    ("Hacker News", "https://news.ycombinator.com/"),
    ("MyFitnessPal", "https://www.myfitnesspal.com/"),
    ("Syncthing",   "http://127.0.0.1:8384/"),
    ("Refree",      "http://127.0.0.1:23119/"),
]
wpi = [
    ("E-Mail", "https://outlook.office.com/mail/"),
    ("International Student Forms", "https://www.wpi.edu/offices/international-house/student/forms"),
    ("WPI Canvas", "https://hub.wpi.edu/Discover-Canvas?traffic_source=canvas"),
    ("WPI Hub", "https://hub.wpi.edu/?utm_campaign=Admitted+Student+Response+Form&utm_medium=email&utm_source=Confirmation+Intl+new"),
    ("PhD Handbook", "https://www.wpi.edu/sites/default/files/docs/Departments-Programs/Robotics-Engineering/PhD_Handbook_2019_0.pdf"),
    ("Academic Calendar 2025-2026", "https://www.wpi.edu/academics/calendar/25-26"),
    ("Student Applications", "https://forms.office.com/pages/designpagev2.aspx?analysis=true&origin=EmailNotification&subpage=design&id=9XacWBXK-UGIS1XsFaBnKm1gUeRaIlxDt_Y2MPpL43VUMUJMMUZORks1RzVDSldMMk1BQlI1N1U1RC4u"),
    ("Lab Files", "https://wpi0-my.sharepoint.com/personal/gli7_wpi_edu/_layouts/15/onedrive.aspx?e=5%3Added85e5885640eeb714e54d2a7c8b1d&sharingv2=true&fromShare=true&at=9&CT=1737433616510&OR=OWA%2DNT%2DMail&CID=1b6adb1e%2D9f18%2D37e4%2D1830%2Dd2edeeb76a45&clickParams=eyJYLUFwcE5hbWUiOiJNaWNyb3NvZnQgT3V0bG9vayBXZWIgQXBwIiwiWC1BcHBWZXJzaW9uIjoiMjAyNTAxMTAwMDMuMTciLCJPUyI6IkxpbnV4IHVuZGVmaW5lZCJ9&cidOR=Client&id=%2Fpersonal%2Fgli7%5Fwpi%5Fedu%2FDocuments%2FLab%20Files&FolderCTID=0x0120003428F273A42BA74BAAF116C7DA5A52A6&view=0"),
    ("Student Portal Profile", "https://international.wpi.edu/index.cfm?FuseAction=scholarPortal.department#/student/student-service-menu/1778"),
    ("Payroll Calendar", "https://www.wpi.edu/sites/default/files/2025-11/2026-Pay-Calendar-with-Deadlines.pdf"),
    ("Events List", "https://mywpi.wpi.edu/events"),
    ("Washburn Schedule", "https://pear-wiki.wpi.edu/washburn"),
]

now = str(int((time.time() + 11644473600) * 1_000_000))
data = {"roots": {"bookmark_bar": {}, "other": {}, "synced": {}}, "version": 1}
if os.path.exists(path):
    with open(path) as f:
        data = json.load(f)
    os.replace(path, path + ".pre-chrome-backup")
roots = data["roots"]
bar = roots.setdefault("bookmark_bar", {"children": [], "date_added": now,
                                        "date_modified": now, "id": "1",
                                        "name": "Bookmarks bar", "type": "folder"})
bar.setdefault("children", [])

used = {int(n["id"]) for r in roots.values() for n in r.get("children", []) if "id" in n}
next_id = max(used, default=1) + 1

def url_node(name, href):
    global next_id
    node = {"date_added": now, "id": str(next_id), "name": name, "type": "url", "url": href}
    next_id += 1
    return node

def folder_node(name, entries):
    global next_id
    node = {"children": [url_node(n, u) for n, u in entries], "date_added": now,
            "date_modified": now, "id": str(next_id), "name": name, "type": "folder"}
    next_id += 1
    return node

existing = {c.get("url") or c.get("name") for c in bar["children"]}
added = []
if "WPI" not in existing:
    added.append(folder_node("WPI", wpi))
added += [url_node(n, u) for n, u in urls if u not in existing]
if not added:
    print("bookmarks already present; nothing to do")
    sys.exit(0)
bar["children"].extend(added)
bar["date_modified"] = now

# Chromium recomputes its checksum; a stale one makes it distrust the file.
data.pop("checksum", None)

with open(path, "w") as f:
    json.dump(data, f, indent=3)
print(f"added {len(added)} entries to bookmarks bar")
PYEOF

echo "done. start Chromium; press Ctrl+Shift+B to show the bookmarks bar."
echo "backup of previous bookmarks: $BOOKMARKS.pre-chrome-backup"
