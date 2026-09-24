import QtQuick
import Quickshell.Io
import qs.colors

// One island atom in the top bar: a 28px rounded pill with centred text.
//
// `maxWidth` (0 = unbounded) turns on the truncating behaviour — clip + elide —
// that only the pills with variable-length labels used.
Rectangle {
    id: root

    property alias text: label.text
    property color textColor: Colors.on_surface
    property int fontPixelSize: 17
    property int horizontalPadding: 16
    property int maxWidth: 0
    property var command: null
    property bool interactive: root.command !== null
    property alias cursorShape: mouse.cursorShape

    signal clicked
    signal wheel(int angleDelta)

    radius: 13
    color: Colors.surface_container
    implicitHeight: 28
    clip: root.maxWidth > 0
    implicitWidth: root.maxWidth > 0
        ? Math.min(label.implicitWidth + root.horizontalPadding, root.maxWidth)
        : label.implicitWidth + root.horizontalPadding

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.interactive
        onClicked: {
            if (root.command)
                proc.running = true;
            root.clicked();
        }
        onWheel: (wheel) => root.wheel(wheel.angleDelta.y)
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        color: root.textColor
        font.pixelSize: root.fontPixelSize
        elide: root.maxWidth > 0 ? Text.ElideRight : Text.ElideNone
        maximumLineCount: 1
    }

    Process {
        id: proc
        command: root.command ?? []
    }
}
