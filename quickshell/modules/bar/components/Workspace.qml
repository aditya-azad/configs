import qs.components
import qs.services as Services

BarPill {
    text: Services.Hyprland.primaryWorkspaceId
    command: ["qs", "ipc", "call", "controlCenter", "changeVisible"]
}
