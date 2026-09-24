import QtQuick
import Quickshell
import qs.components
import qs.services as Services
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: calendarWindow

    visible: Services.CalendarState.open || wrapper.opacity > 0.001
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    focusable: true

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    MouseArea {
        id: closeOnOutside
        anchors.fill: parent
        enabled: Services.CalendarState.open
        onClicked: Services.CalendarState.open = false
    }

    Connections {
        target: Services.CalendarState
        function onOpenChanged() {
            if (Services.CalendarState.open)
                cal.resetView()
        }
    }

    Item {
        id: wrapper
        width: cal.implicitWidth
        height: cal.implicitHeight
        x: Math.max(8, Math.round(
            Services.CalendarState.anchorX
            + Services.CalendarState.anchorWidth / 2
            - width / 2))
        transformOrigin: Item.Top

        opacity: Services.CalendarState.open ? 1 : 0
        scale: Services.CalendarState.open ? 1 : 0.94
        y: Services.CalendarState.open ? 0 : -8

        Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
        Behavior on y { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }

        MouseArea {
            anchors.fill: parent
        }

        Calendar {
            id: cal
            anchors.fill: parent
        }
    }

    IpcHandler {
        target: "calendarWindow"
        function toggle(): void {
            Services.CalendarState.open = !Services.CalendarState.open
        }
    }
}
