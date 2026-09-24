import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: panel
    anchor: PanelWindowAnchor.Top
    width: screen.width
    height: 32
    color: "#1a1a1a"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Repeater {
            model: HyprlandWorkspaces {}
            Rectangle {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                radius: 4
                color: model.active ? "#33ccff" : "transparent"
                border.color: model.active ? "#33ccff" : "#595959"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: model.id
                    color: model.active ? "#1a1a1a" : "white"
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + model.id)
                }
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            color: "white"
            font.pixelSize: 12
            text: Hyprland.activeWindow ? Hyprland.activeWindow.title : ""
            elide: Text.ElideRight
            Layout.maximumWidth: panel.width * 0.4
        }

        Item { Layout.fillWidth: true }

        Text {
            id: clockText
            color: "white"
            font.pixelSize: 12
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "h:mm AP")
            }
        }
    }
}
