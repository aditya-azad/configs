pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs.services as Services

Singleton {
    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSource,
            Pipewire.defaultAudioSink,
            Pipewire.nodes,
            Pipewire.links
        ]
    }

    property var sinks: Pipewire.nodes.values.filter(node => node.isSink && !node.isStream && node.audio)
    property PwNode defaultSink: Pipewire.defaultAudioSink

    property var sources: Pipewire.nodes.values.filter(node => !node.isSink && !node.isStream && node.audio)
    property PwNode defaultSource: Pipewire.defaultAudioSource

    property real volume: (defaultSink?.audio?.volume > 1 ? 1 : defaultSink?.audio?.volume) ?? 0
    property bool muted: defaultSink?.audio?.muted ?? false

    property real sourceVolume: (defaultSource?.audio?.volume > 1 ? 1 : defaultSource?.audio?.volume) ?? 0
    property bool sourceMuted: defaultSource?.audio?.muted ?? false

    property string statePath: Quickshell.env("HOME") + "/.config/quickshell/microphone.json"
    property real savedSourceVolume: {
        const text = micStateFile.text()
        if (!text || !text.trim()) return -1
        try {
            const obj = JSON.parse(text)
            const v = obj.volume
            return (typeof v === "number" && v >= 0 && v <= 1) ? v : -1
        } catch (e) {
            return -1
        }
    }
    property bool sourceVolumeRestored: false

    FileView {
        id: micStateFile
        path: statePath
        blockLoading: true
    }

    FileView {
        id: micStateWriter
        path: statePath
    }

    property real _pendingSaveVolume: -1
    Timer {
        id: saveSourceTimer
        interval: 250
        onTriggered: {
            if (_pendingSaveVolume >= 0)
                micStateWriter.setText(JSON.stringify({ volume: _pendingSaveVolume }))
        }
    }

    Connections {
        id: restoreConn
        target: defaultSource
        function onReadyChanged() { tryRestoreSourceVolume() }
    }

    function tryRestoreSourceVolume() {
        if (sourceVolumeRestored) return
        if (savedSourceVolume < 0) return
        if (defaultSource?.ready && defaultSource?.audio) {
            defaultSource.audio.muted = false
            defaultSource.audio.volume = savedSourceVolume
            sourceVolumeRestored = true
        }
    }

    function saveSourceVolume(v: real): void {
        _pendingSaveVolume = v
        saveSourceTimer.restart()
    }

    Connections {
        id: audioConn
        target: defaultSink && defaultSink.audio ? defaultSink.audio : null

        function onVolumeChanged() {
            let vol = Math.min(defaultSink.audio.volume * 100, 100)  // Clamp to 100
            Services.Osd.show("volume", vol)
        }

        function onMutedChanged() {
            let vol = defaultSink.audio.muted ? 0 : Math.min(defaultSink.audio.volume * 100, 100)
            Services.Osd.show("volume", vol)
        }
    }

    Connections {
        id: sourceAudioConn
        target: defaultSource && defaultSource.audio ? defaultSource.audio : null

        function onVolumeChanged() {
            let vol = Math.min(defaultSource.audio.volume * 100, 100)
            Services.Osd.show("microphone", vol)
        }

        function onMutedChanged() {
            let vol = defaultSource.audio.muted ? 0 : Math.min(defaultSource.audio.volume * 100, 100)
            Services.Osd.show("microphone", vol)
        }
    }

    function setVolume(to: real): void {
        if (defaultSink?.ready && defaultSink?.audio) {
            defaultSink.audio.muted = false;
            let val = Math.max(0, Math.min(1, to));
            defaultSink.audio.volume = val
            Services.Osd.show("volume", val * 100)
        }
    }

    function setSourceVolume(to: real): void {
        if (defaultSource?.ready && defaultSource?.audio) {
            defaultSource.audio.muted = false;
            let val = Math.max(0, Math.min(1, to));
            defaultSource.audio.volume = val
            Services.Osd.show("microphone", val * 100)
            saveSourceVolume(val)
        }
    }

    function setDefaultSink(sink: PwNode): void {
        Pipewire.preferredDefaultAudioSink = sink;
    }

    function setDefaultSource(source: PwNode): void {
        Pipewire.preferredDefaultAudioSource = source;
    }

    Component.onCompleted: tryRestoreSourceVolume()

    function init() {
    }
}