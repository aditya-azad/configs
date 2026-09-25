import QtQuick
import qs.modules.bar.components
import qs.services as Services
import qs.colors

Item {
    id: topBar

    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: 32

    Item {
        anchors.fill: parent

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Workspace {}
            Temp {}
            Memory {}
            Battery {}
            Cpu {}
        }

        Row {
            anchors.centerIn: parent
            Clock {}
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            SystemTray {}
            Network {}
            Bluetooth {}
            Volume {}
            Microphone {}
        }
    }
}
