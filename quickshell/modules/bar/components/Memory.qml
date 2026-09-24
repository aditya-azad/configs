import qs.components
import qs.services as Services
import qs.Core

BarPill {
    text: Icons.memory + " " + Math.round(Services.System.ram) + "%"
    horizontalPadding: 20
}
