pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell
import qs.services

Singleton {
    id: stats

    property real cpu: 0
    property real ram: 0
    property real disk: 0
    property real temp: 0
    property string uptime: "0h 0m"

    property int brightness: 0
    property int lastBrightness: -1
    property string brightnessDevice: ""

    Process {
        id: brightnessDevProc
        running: true
        command: ["sh", "-c", "for d in /sys/class/backlight/*; do readlink -f \"$d\" | grep -q /drm/ && { echo \"${d##*/}\"; exit; }; done; mx=0; dev=\"\"; for d in /sys/class/backlight/*; do m=$(cat \"$d/max_brightness\" 2>/dev/null || echo 0); [ \"$m\" -gt \"$mx\" ] && { mx=$m; dev=\"${d##*/}\"; }; done; echo \"$dev\""]
        stdout: StdioCollector {
            onStreamFinished: {
                let dev = text.trim()
                if (dev) {
                    stats.brightnessDevice = dev
                    brightnessProc.running = true
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            ramProc.running = true
            diskProc.running = true
            tempProc.running = true
            uptimeProc.running = true
        }
    }

    Timer {
        interval: 500
        running: stats.brightnessDevice !== ""
        repeat: true
        onTriggered: brightnessProc.running = true
    }

    Process {
        id: cpuProc
        command: ["bash","-c","top -bn1 | grep 'Cpu(s)' | awk '{print 100-$8}'"]
        stdout: StdioCollector {
            onStreamFinished: stats.cpu = parseFloat(text) || 0
        }
    }

    Process {
        id: ramProc
        command: ["bash","-c","free | awk '/Mem:/ {print $3/$2 * 100.0}'"]
        stdout: StdioCollector {
            onStreamFinished: stats.ram = parseFloat(text) || 0
        }
    }

    Process {
        id: diskProc
        command: ["bash","-c","df -h / | awk 'NR==2 {print $5}' | sed 's/%//'"]
        stdout: StdioCollector {
            onStreamFinished: stats.disk = parseFloat(text) || 0
        }
    }

    Process {
        id: tempProc
        command: ["bash","-c","for d in /sys/class/hwmon/*; do [ \"$(cat $d/name 2>/dev/null)\" = coretemp ] || continue; for f in $d/temp*_label; do [ \"$(cat $f 2>/dev/null)\" = 'Package id 0' ] && awk '{printf \"%d\", $1/1000}' \"${f%_label}_input\"; done; done"]
        stdout: StdioCollector {
            onStreamFinished: stats.temp = parseFloat(text) || 0
        }
    }

    Process {
        id: uptimeProc
        command: ["bash","-c","cat /proc/uptime | awk '{print int($1)}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let seconds = parseInt(text) || 0
                let hours = Math.floor(seconds / 3600)
                let minutes = Math.floor((seconds % 3600) / 60)
                stats.uptime = hours + "h " + minutes + "m"
            }
        }
    }

    Process {
        id: brightnessProc
        command: ["sh", "-c", "brightnessctl -d " + stats.brightnessDevice + " -m | cut -d, -f4 | tr -d '%'"]

        stdout: StdioCollector {
            onStreamFinished: {
                let v = parseInt(text) || 0
                stats.brightness = v
            }
        }
    }

    onBrightnessChanged: {
        if (lastBrightness !== -1 && brightness !== lastBrightness) {
            Osd.show("brightness", brightness)
        }
        lastBrightness = brightness
    }

    function setBrightness(v) {
        if (!stats.brightnessDevice) return
        setBrightnessProc.command = ["brightnessctl", "-d", stats.brightnessDevice, "set", v + "%"]
        setBrightnessProc.running = true
        stats.brightness = v
        Osd.show("brightness", v)
    }

    Process { id: setBrightnessProc }
}