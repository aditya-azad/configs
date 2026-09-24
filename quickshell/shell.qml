import QtQuick
import Quickshell
import qs.modules.network
import qs.modules.control
import qs.modules.calendar
import qs.modules.bar
import Quickshell.Io
import qs.services as Services
import qs.components
import qs.Osd
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.modules.launcher

ShellRoot {
    id: root

    function primaryScreen() {
        const monitors = Services.Hyprland.monitorsInfo
        if (!monitors || monitors.length === 0) return null
        let primary = monitors[0]
        for (let i = 1; i < monitors.length; i++) {
            const m = monitors[i]
            if (m.x < primary.x || (m.x === primary.x && m.y < primary.y))
                primary = m
        }
        const screens = Quickshell.screens
        for (let i = 0; i < screens.length; i++) {
            if (screens[i].name === primary.name)
                return screens[i]
        }
        return null
    }

    NotificationToasts { screen: primaryScreen() }
    CalendarWindow {}

    PanelWindow {
        id: barPanel
        anchors.top: true
        anchors.left: true
        anchors.right: true
        margins.top: 8
        margins.left: 4
        margins.right: 4
        implicitHeight: 32
        screen: primaryScreen()
        exclusionMode: ExclusionMode.Exclusive
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top

        TopBar {
            id: topBar
        }
    }

    PanelWindow {
        id: overlayPanel
        exclusionMode: ExclusionMode.Ignore
        screen: primaryScreen()
        implicitHeight: screen.height
        implicitWidth: screen.width
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: launcherWindow.isOpen
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.OnDemand

        Loader {
            id: networkPanelLoader
            active: false
            anchors.fill: parent
            sourceComponent: NetworkPanel {
                id: networkPanel
            }
        }

        OsdWindow {}

        Loader {
            id: controlCenterLoader
            active: false
            anchors.fill: parent
            sourceComponent: ControlCenter {
                id: controlCenter
            }
            focus: true
        }

        LauncherWindow {
            id: launcherWindow
        }

        mask: Region {
            Region {
                item: networkPanelLoader.item && networkPanelLoader.item.visible ? networkPanelLoader.item : null
            }
            Region {
                item: controlCenterLoader.item && controlCenterLoader.item.visible ? controlCenterLoader.item : null
            }
            Region {
                item: launcherWindow.isOpen ? launcherWindow : null
            }
        }
    }

    Timer {
        id: closeNetworkTimer
        interval: 600
        onTriggered: networkPanelLoader.active = false
    }

    Connections {
        target: networkPanelLoader.item
        function onOpenedChanged() {
            if (networkPanelLoader.item && !networkPanelLoader.item.opened) {
                closeNetworkTimer.start()
            }
        }
    }

    Timer {
        id: closeControlCenterTimer
        interval: 600
        onTriggered: controlCenterLoader.active = false
    }

    Connections {
        target: controlCenterLoader.item
        function onOpenedChanged() {
            if (controlCenterLoader.item && !controlCenterLoader.item.opened) {
                closeControlCenterTimer.start()
            }
        }
    }

    IpcHandler {
        target: "networkPanel"

        function changeVisible(tab: string): void {
            if (!networkPanelLoader.active)
                networkPanelLoader.active = true

            const panel = networkPanelLoader.item
            if (!panel)
                return

            if (panel.opened) {
                panel.opened = false
                return
            }

            if (tab === "wifi")
                panel.currentTab = 0
            else if (tab === "bluetooth")
                panel.currentTab = 1

            if (tab !== undefined)
                panel.opened = true
            else
                panel.opened = !panel.opened
        }
    }

    IpcHandler {
        target: "controlCenter"
        function changeVisible(): void {
            if (!controlCenterLoader.active) {
                controlCenterLoader.active = true
                controlCenterLoader.item.opened = true
            } else {
                controlCenterLoader.item.opened = !controlCenterLoader.item.opened
            }
        }
    }

    IpcHandler {
        target: "launcherWindow"

        function toggle() {
            launcherWindow.toggle()
        }
    }
}
