import qs.components
import qs.services as Services
import qs.Core

BarPill {
    text: micIcon + " " + Math.round(Services.Volume.sourceVolume * 100) + "%"
    horizontalPadding: 24
    maxWidth: 160
    interactive: true

    onWheel: (angleDelta) => {
        const step = 0.05
        const dir = angleDelta > 0 ? 1 : -1
        Services.Volume.setSourceVolume(Services.Volume.sourceVolume + step * dir)
    }

    property string micIcon: Services.Volume.sourceMuted ? Icons.microphoneMuted : Icons.microphone
}
