#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

[[ -x /usr/bin/brave-browser ]] || curl -fsS https://dl.brave.com/install.sh | sudo sh

sudo mkdir -p /etc/brave/policies/managed
sudo chmod 0755 /etc/brave/policies/managed

tmp=$(mktemp)
cat > "$tmp" <<'JSON'
{
  "BookmarkBarEnabled": true,
  "BrowserSignin": 0,
  "ExtensionDeveloperModeSettings": "Allow",
  "BraveNewsDisabled": true,
  "BraveAIChatEnabled": false,
  "ManagedBookmarks": [
    {
      "name": "WPI",
      "children": [
        { "name": "E-Mail", "url": "https://outlook.office.com/mail/" },
        { "name": "International Student Forms", "url": "https://www.wpi.edu/offices/international-house/student/forms" },
        { "name": "WPI Canvas", "url": "https://hub.wpi.edu/Discover-Canvas?traffic_source=canvas" },
        { "name": "WPI Hub", "url": "https://hub.wpi.edu/?utm_campaign=Admitted+Student+Response+Form&utm_medium=email&utm_source=Confirmation+Intl+new" },
        { "name": "PhD Handbook", "url": "https://www.wpi.edu/sites/default/files/docs/Departments-Programs/Robotics-Engineering/PhD_Handbook_2019_0.pdf" },
        { "name": "Academic Calendar 2025-2026", "url": "https://www.wpi.edu/academics/calendar/25-26" },
        { "name": "Student Applications", "url": "https://forms.office.com/pages/designpagev2.aspx?analysis=true&origin=EmailNotification&subpage=design&id=9XacWBXK-UGIS1XsFaBnKm1gUeRaIlxDt_Y2MPpL43VUMUJMMUZORks1RzVDSldMMk1BQlI1N1U1RC4u" },
        { "name": "Lab Files", "url": "https://wpi0-my.sharepoint.com/personal/gli7_wpi_edu/_layouts/15/onedrive.aspx?e=5%3Added85e5885640eeb714e54d2a7c8b1d&sharingv2=true&fromShare=true&at=9&CT=1737433616510&OR=OWA%2DNT%2DMail&CID=1b6adb1e%2D9f18%2D37e4%2D1830%2Dd2edeeb76a45&clickParams=eyJYLUFwcE5hbWUiOiJNaWNyb3NvZnQgT3V0bG9vayBXZWIgQXBwIiwiWC1BcHBWZXJzaW9uIjoiMjAyNTAxMTAwMDMuMTciLCJPUyI6IkxpbnV4IHVuZGVmaW5lZCJ9&cidOR=Client&id=%2Fpersonal%2Fgli7%5Fwpi%5Fedu%2FDocuments%2FLab%20Files&FolderCTID=0x0120003428F273A42BA74BAAF116C7DA5A52A6&view=0" },
        { "name": "Student Portal Profile", "url": "https://international.wpi.edu/index.cfm?FuseAction=scholarPortal.department#/student/student-service-menu/1778" },
        { "name": "Payroll Calendar", "url": "https://www.wpi.edu/sites/default/files/2025-11/2026-Pay-Calendar-with-Deadlines.pdf" },
        { "name": "Events List", "url": "https://mywpi.wpi.edu/events" },
        { "name": "Washburn Schedule", "url": "https://pear-wiki.wpi.edu/washburn" }
      ]
    },
    { "name": "OpenRouter", "url": "https://openrouter.ai/settings/credits" },
    { "name": "Hacker News", "url": "https://news.ycombinator.com/" },
    { "name": "MyFitnessPal", "url": "https://www.myfitnesspal.com/" },
    { "name": "Refree", "url": "http://127.0.0.1:23119/" }
  ],
  "ExtensionInstallForcelist": [
    "dbepggeogbaibhgnhhndojpepiihcmeb;https://clients2.google.com/service/update2/crx",
    "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx",
    "ekhagklcjbdpajgpjgmbionohlpdbjgc;https://clients2.google.com/service/update2/crx"
  ]
}
JSON
sudo install -m 0644 "$tmp" /etc/brave/policies/managed/settings.json
rm -f "$tmp"
