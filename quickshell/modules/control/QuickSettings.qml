import Quickshell
import qs.components
import QtQuick.Layouts
import Quickshell.Io
import qs.services as Services

ColumnLayout {
    id: quickSettings
    Layout.fillWidth: true
    Layout.leftMargin: 20
    Layout.rightMargin: 20
    Layout.topMargin: 20
    Layout.bottomMargin: 20
    spacing: 14

    Process { id: proc }
    function run(cmd) {
        if (cmd instanceof Array) proc.exec(cmd)
        else proc.exec(["bash", "-c", cmd])
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 3
        columnSpacing: 12
        rowSpacing: 12

        ToggleTile {
            label: "Wi-Fi"
            icon: Services.Network.icon
            active: Services.Network.wifiEnabled
            onClicked: Services.Network.toggleWifi()
        }

        ToggleTile {
            label: "Bluetooth"
            icon: "󰂯"
            active: Services.Bluetooth.defaultAdapter?.enabled ?? false
            onClicked: Services.Bluetooth.defaultAdapter.enabled = !Services.Bluetooth.defaultAdapter.enabled
        }

        ToggleTile {
            label: "Lock"
            icon: "󰌾"
            active: false
            onClicked: run("hyprlock")
        }
    }
}