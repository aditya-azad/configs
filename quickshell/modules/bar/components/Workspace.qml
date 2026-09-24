import qs.components
import qs.services as Services

BarPill {
    text: Services.Hyprland.focusedWorkspaceId
    command: ["qs", "ipc", "call", "controlCenter", "changeVisible"]
}
