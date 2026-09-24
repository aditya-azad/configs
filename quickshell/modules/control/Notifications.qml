import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services as Services
import qs.colors
import qs.components

Item {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: notifModel.length > 0 ? notifSection.height : 0
    Layout.topMargin: 10
    Layout.bottomMargin: 10
    visible: notifModel.length > 0

    readonly property var notifModel: Services.Notification.history

    function clearAll() {
        while (Services.Notification.data.length > 0)
            Services.Notification.data.splice(0, 1)
    }

    ColumnLayout {
        id: notifSection
        width: parent.width
        spacing: 12

        Item {
            Layout.fillWidth: true
            Layout.topMargin: 8
            implicitHeight: 36

            StyledText {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                text: "Notifications"
                color: Colors.on_surface_variant
                font.pixelSize: 11
                font.letterSpacing: 1.2
                font.weight: Font.Medium
            }

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                StyledText {
                    text: notifModel.length.toString()
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    color: Colors.on_surface_variant
                    visible: notifModel.length > 0
                }

                Button {
                    text: "Clear All"
                    font.pixelSize: 11
                    visible: notifModel.length > 0
                    onClicked: clearAll()

                    contentItem: StyledText {
                        text: parent.text
                        font: parent.font
                        color: Colors.primary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Card {
                        implicitWidth: 70
                        implicitHeight: 28
                        radius: 14

                        color: parent.pressed ?
                            Colors.withAlpha(Colors.primary, 0.15)
                            : parent.hovered ?
                                Colors.withAlpha(Colors.primary, 0.08)
                                : Colors.surface_container_high
                    }
                }
            }
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.preferredHeight: notifModel.length > 0
                ? Math.min(list.contentHeight, 400)
                : 0
            visible: notifModel.length > 0
            clip: true
            spacing: 8
            model: notifModel
            boundsBehavior: Flickable.StopAtBounds

            Behavior on Layout.preferredHeight {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            delegate: Card {
                width: list.width
                height: contentColumn.implicitHeight + 20
                radius: 12

                color: Colors.surface_container_high

                required property var modelData

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: Colors.primary
                    opacity: mouseArea.containsMouse ? 0.05 : 0
                    Behavior on opacity { NumberAnimation { duration: 120 } }
                }

                RowLayout {
                    id: contentColumn
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: "transparent"
                        clip: true
                        Layout.alignment: Qt.AlignTop

                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            smooth: true

                            source: {
                                const icon = modelData.appIcon;
                                if (icon) {
                                    if (icon.startsWith("/"))
                                        return "file://" + icon;
                                    if (icon.includes("://"))
                                        return icon;
                                    if (Quickshell.iconPath(icon, true).length > 0)
                                        return "image://icon/" + icon;
                                }
                                return Services.AppRegistry.fallbackIcon;
                            }

                            onStatusChanged: {
                                if (status === Image.Error)
                                    source = Services.AppRegistry.fallbackIcon;
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        RowLayout {
                            Layout.fillWidth: true

                            StyledText {
                                text: modelData.appName || "App"
                                font.pixelSize: 11
                                font.weight: Font.Medium
                                color: Colors.primary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            StyledText {
                                text: modelData.timeStr
                                font.pixelSize: 10
                                color: Colors.on_surface_variant
                                opacity: 0.7
                            }
                        }

                        StyledText {
                            text: modelData.summary
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            visible: text.length > 0
                        }

                        StyledText {
                            text: modelData.body
                            font.pixelSize: 12
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                            color: Colors.on_surface_variant
                            maximumLineCount: 4
                            elide: Text.ElideRight
                            visible: text.length > 0
                        }
                    }
                }
            }
        }
    }
}
