import qs.components
import qs.services as Services

BarPill {
    text: Services.Hyprland.primaryWorkspaceBase
    command: ["qs", "ipc", "call", "controlCenter", "changeVisible"]
}
