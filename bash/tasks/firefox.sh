#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ -x /usr/bin/firefox ]] || {
  sudo install -d -m 0755 /etc/apt/keyrings
  curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg \
    | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
    | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
  sudo tee /etc/apt/preferences.d/mozilla > /dev/null <<'EOF'
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF
  sudo apt-get update
  sudo apt-get install -y firefox
}

sudo install -d -m 0755 /etc/firefox/policies
tmp=$(mktemp)
cat > "$tmp" <<'JSON'
{
  "policies": {
    "DisplayBookmarksToolbar": true,
    "Bookmarks": [
      { "Title": "E-Mail", "URL": "https://outlook.office.com/mail/", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "International Student Forms", "URL": "https://www.wpi.edu/offices/international-house/student/forms", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "WPI Canvas", "URL": "https://hub.wpi.edu/Discover-Canvas?traffic_source=canvas", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "WPI Hub", "URL": "https://hub.wpi.edu/?utm_campaign=Admitted+Student+Response+Form&utm_medium=email&utm_source=Confirmation+Intl+new", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "PhD Handbook", "URL": "https://www.wpi.edu/sites/default/files/docs/Departments-Programs/Robotics-Engineering/PhD_Handbook_2019_0.pdf", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "Academic Calendar 2025-2026", "URL": "https://www.wpi.edu/academics/calendar/25-26", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "Student Applications", "URL": "https://forms.office.com/pages/designpagev2.aspx?analysis=true&origin=EmailNotification&subpage=design&id=9XacWBXK-UGIS1XsFaBnKm1gUeRaIlxDt_Y2MPpL43VUMUJMMUZORks1RzVDSldMMk1BQlI1N1U1RC4u", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "Lab Files", "URL": "https://wpi0-my.sharepoint.com/personal/gli7_wpi_edu/_layouts/15/onedrive.aspx?e=5%3Added85e5885640eeb714e54d2a7c8b1d&sharingv2=true&fromShare=true&at=9&CT=1737433616510&OR=OWA%2DNT%2DMail&CID=1b6adb1e%2D9f18%2D37e4%2D1830%2Dd2edeeb76a45&clickParams=eyJYLUFwcE5hbWUiOiJNaWNyb3NvZnQgT3V0bG9vayBXZWIgQXBwIiwiWC1BcHBWZXJzaW9uIjoiMjAyNTAxMTAwMDMuMTciLCJPUyI6IkxpbnV4IHVuZGVmaW5lZCJ9&cidOR=Client&id=%2Fpersonal%2Fgli7%5Fwpi%5Fedu%2FDocuments%2FLab%20Files&FolderCTID=0x0120003428F273A42BA74BAAF116C7DA5A52A6&view=0", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "Student Portal Profile", "URL": "https://international.wpi.edu/index.cfm?FuseAction=scholarPortal.department#/student/student-service-menu/1778", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "Payroll Calendar", "URL": "https://www.wpi.edu/sites/default/files/2025-11/2026-Pay-Calendar-with-Deadlines.pdf", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "Events List", "URL": "https://mywpi.wpi.edu/events", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "Washburn Schedule", "URL": "https://pear-wiki.wpi.edu/washburn", "Placement": "toolbar", "Folder": "WPI" },
      { "Title": "OpenRouter", "URL": "https://openrouter.ai/settings/credits", "Placement": "toolbar" },
      { "Title": "Hacker News", "URL": "https://news.ycombinator.com/", "Placement": "toolbar" },
      { "Title": "MyFitnessPal", "URL": "https://www.myfitnesspal.com/", "Placement": "toolbar" },
      { "Title": "Syncthing", "URL": "http://127.0.0.1:8384/", "Placement": "toolbar" },
      { "Title": "Refree", "URL": "http://127.0.0.1:23119/", "Placement": "toolbar" }
    ],
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi",
        "https://www.zotero.org/download/connector/dl?browser=firefox"
      ]
    }
  }
}
JSON
sudo install -m 0644 "$tmp" /etc/firefox/policies/policies.json
rm -f "$tmp"
