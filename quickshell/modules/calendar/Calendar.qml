import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.colors
import qs.components
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property date currentDate: new Date()   // month being shown
    property date selectedDate: new Date()  // highlighted day

    readonly property int dispY: currentDate.getFullYear()
    readonly property int dispM: currentDate.getMonth()

    implicitWidth: 360
    implicitHeight: calCard.height

    function daysInMonth(y, m) { return new Date(y, m + 1, 0).getDate() }
    function firstDayOffset(y, m) { return (new Date(y, m, 1).getDay() + 6) % 7 }

    function isToday(y, m, d) {
        const t = new Date()
        return t.getFullYear() === y && t.getMonth() === m && t.getDate() === d
    }
    function isSelected(y, m, d) {
        return selectedDate.getFullYear() === y &&
               selectedDate.getMonth() === m &&
               selectedDate.getDate() === d
    }

    function monthModel() {
        const y = dispY, m = dispM
        const offset = firstDayOffset(y, m)
        const total = daysInMonth(y, m)
        let arr = []
        for (let i = 0; i < offset; i++) arr.push({ day: 0 })
        for (let d = 1; d <= total; d++) arr.push({ day: d })
        while (arr.length % 7 !== 0) arr.push({ day: 0 })
        return arr
    }

    function resetView() {
        currentDate = new Date()
        selectedDate = new Date()
    }

    // ───────────────────────── Calendar card ─────────────────────────
    Card {
        id: calCard
        width: root.width
        y: 0
        height: col.height + 32
        radius: 26
        border.width: 0
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 3
            radius: 16
            samples: 24
            color: Colors.shadow
        }

        Rectangle {
            width: calCard.width
            height: calCard.radius
            color: calCard.color
        }

        Column {
            id: col
            x: 16; y: 16
            width: calCard.width - 32
            spacing: 14

            property real spacingCell: 4
            property real cellW: (width - spacingCell * 6) / 7

            // ── Header: month / year with nav ──
            RowLayout {
                width: col.width
                spacing: 6

                ClickableRect {
                    id: prevHoverRect
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    radius: 17
                    color: prevHoverRect.hovered ? Colors.surface_container_highest : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                    StyledText {
                        anchors.centerIn: parent
                        text: "‹"
                        font.pixelSize: 22
                        color: Colors.on_surface_variant
                    }
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.currentDate = new Date(root.dispY, root.dispM - 1, 1)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    StyledText {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: Qt.formatDate(root.currentDate, "MMMM")
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }
                    StyledText {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: Qt.formatDate(root.currentDate, "yyyy")
                        font.pixelSize: 11
                        color: Colors.on_surface_variant
                        opacity: 0.8
                    }
                }

                ClickableRect {
                    id: nextHoverRect
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    radius: 17
                    color: nextHoverRect.hovered ? Colors.surface_container_highest : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                    StyledText {
                        anchors.centerIn: parent
                        text: "›"
                        font.pixelSize: 22
                        color: Colors.on_surface_variant
                    }
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.currentDate = new Date(root.dispY, root.dispM + 1, 1)
                }
            }

            // ── Weekday header (same column geometry as the grid below) ──
            Row {
                spacing: col.spacingCell
                width: col.width
                Repeater {
                    model: ["M", "T", "W", "T", "F", "S", "S"]
                    delegate: Item {
                        width: col.cellW
                        height: 22
                        StyledText {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: index >= 5 ? Colors.tertiary
                                              : Colors.on_surface_variant
                            opacity: 0.85
                        }
                    }
                }
            }

            // ── Day grid ──
            Grid {
                id: daysGrid
                width: col.width
                columns: 7
                spacing: col.spacingCell

                Repeater {
                    model: root.monthModel()

                    delegate: Item {
                        id: cell
                        width: col.cellW
                        height: 42

                        property bool valid: modelData.day > 0
                        property int col7: index % 7
                        property bool weekend: col7 >= 5
                        property var cellDate: valid ? new Date(root.dispY, root.dispM, modelData.day) : null
                        property bool today: valid && root.isToday(root.dispY, root.dispM, modelData.day)
                        property bool selected: valid && root.isSelected(root.dispY, root.dispM, modelData.day)

                        Rectangle {
                            id: pill
                            anchors.centerIn: parent
                            width: 38
                            height: 38
                            radius: 19
                            color: cell.today
                                   ? Colors.primary
                                   : (cellMa.containsMouse && cell.valid
                                      ? Colors.surface_container_highest
                                      : "transparent")
                            border.width: cell.selected && !cell.today ? 1.5 : 0
                            border.color: Colors.primary
                            Behavior on color { ColorAnimation { duration: 150 } }

                            StyledText {
                                anchors.centerIn: parent
                                text: cell.valid ? modelData.day : ""
                                font.pixelSize: 13
                                font.weight: (cell.today || cell.selected) ? Font.DemiBold : Font.Normal
                                color: cell.today ? Colors.on_primary
                                      : cell.selected ? Colors.primary
                                      : cell.weekend ? Colors.on_surface_variant
                                      : Colors.on_surface
                            }
                        }

                        MouseArea {
                            id: cellMa
                            anchors.fill: parent
                            enabled: cell.valid
                            hoverEnabled: true
                            cursorShape: cell.valid ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: root.selectedDate = cell.cellDate
                        }
                    }
                }
            }
        }
    }
}