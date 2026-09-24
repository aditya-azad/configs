import Quickshell
import Quickshell.Wayland
import Quickshell.DBus
import QtQuick

DBusService {
    bus: DBus.Session
    service: "org.freedesktop.Notifications"
    path: "/org/freedesktop/Notifications"
    interface: "org.freedesktop.Notifications"

    function Notify(app_name, replaces_id, app_icon, summary, body, actions, hints, expire_timeout) {
        var timeout = expire_timeout > 0 ? expire_timeout : 5000
        var popup = notifComp.createObject(null, {
            summary: summary,
            body: body,
            timeout: timeout
        })
        popup.show()
        return 1
    }

    function GetCapabilities() {
        return ["body"]
    }

    function CloseNotification(id) {}

    function GetServerInformation() {
        return ["quickshell", "quickshell", "1.0", "1.2"]
    }

    Component {
        id: notifComp
        PanelWindow {
            property string summary
            property string body
            property int timeout
            anchor: PanelWindowAnchor.Top | PanelWindowAnchor.Right
            width: 400
            height: 80
            color: "#2a2a2a"

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                Text {
                    text: summary
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                    width: parent.width
                    elide: Text.ElideRight
                }

                Text {
                    text: body
                    color: "#cccccc"
                    font.pixelSize: 12
                    width: parent.width
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                }
            }

            Timer {
                interval: parent.timeout
                running: true
                onTriggered: parent.destroy()
            }
        }
    }
}
