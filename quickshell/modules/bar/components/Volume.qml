import qs.components
import qs.services as Services
import qs.Core

BarPill {
    text: volumeIcon + " " + Math.round(Services.Volume.volume * 100) + "%"
    horizontalPadding: 20
    maxWidth: 160
    interactive: true

    onWheel: (angleDelta) => {
        const step = 0.05
        const dir = angleDelta > 0 ? 1 : -1
        Services.Volume.setVolume(Services.Volume.volume + step * dir)
    }

    property string volumeIcon: {
        if (Services.Volume.muted) return Icons.volumeMuted

        const v = Services.Volume.volume * 100
        if (v <= 0) return Icons.volumeZero
        if (v < 33) return Icons.volumeLow
        if (v < 66) return Icons.volumeMedium
        return Icons.volumeHigh
    }
}
