pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property bool open: false
    property var menuHandle: null
    property real anchorX: 0
    property real anchorY: 0

    function openAt(menu, x, y) {
        menuHandle = menu
        anchorX = x
        anchorY = y
        open = true
    }

    function close() {
        open = false
    }
}
