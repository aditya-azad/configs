import QtQuick
import qs.modules.bar.components
import qs.services as Services
import qs.colors

Item {
    id: topBar

    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: 42

    Item {
        anchors.fill: parent

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Cpu {}
            Battery {}
            Clock {}
            Bluetooth {}
        }

        MediaPill {
            anchors.centerIn: parent
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Network {}
            Temp {}
            Volume {}
            Memory {}
            SystemTray {}
        }
    }
}
