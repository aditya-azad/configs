pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root
    readonly property BluetoothAdapter defaultAdapter: Bluetooth.defaultAdapter
    readonly property list<BluetoothDevice> devices: defaultAdapter?.devices?.values ?? []
    readonly property BluetoothDevice activeDevice: devices.find(d => d.connected) ?? null
    readonly property string icon: {
        if (!defaultAdapter?.enabled) {
            return "bluetooth_disabled"
        }

        if (activeDevice) {
            return "bluetooth_connected"
        }

        return defaultAdapter.discovering ? "bluetooth_searching" : "bluetooth"
    }

    property string pendingConnectAddress: ""

    function connectDevice(device) {
        if (!device) return
        if (device.connected) {
            device.disconnect()
            return
        }
        device.trusted = true
        if (device.paired) {
            device.connect()
        } else {
            root.pendingConnectAddress = device.address
            pairTimer.restart()
            pairTimeout.restart()
            device.pair()
        }
    }

    function _deviceForAddress(address) {
        return root.devices.find(d => d.address === address) ?? null
    }

    Timer {
        id: pairTimer
        interval: 500
        repeat: true
        onTriggered: {
            if (root.pendingConnectAddress === "") {
                pairTimer.stop()
                return
            }
            var d = root._deviceForAddress(root.pendingConnectAddress)
            if (!d) {
                pairTimer.stop()
                return
            }
            if (d.paired) {
                root.pendingConnectAddress = ""
                pairTimer.stop()
                d.trusted = true
                d.connect()
            }
        }
    }

    Timer {
        id: pairTimeout
        interval: 30000
        onTriggered: {
            root.pendingConnectAddress = ""
            pairTimer.stop()
        }
    }
}
