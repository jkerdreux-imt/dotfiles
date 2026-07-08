-- =============================================================================
-- WORKSPACE UTILITIES
-- Usage: local ws = require("workspace")
--        ws.toggle(target_id)
--        ws.cycle("next"|"prev")
-- =============================================================================

local ws = {}

-- Last workspace visited, used for toggle-back
local last_ws = nil

-- Toggle to workspace <target>. If already on it, jump back to the last one.
function ws.toggle(target)
    local current = hl.get_active_workspace()
    if not current then return end

    if current.id == target then
        if last_ws then
            hl.dispatch(hl.dsp.focus({ workspace = last_ws }))
        end
    else
        last_ws = current.id
        hl.dispatch(hl.dsp.focus({ workspace = target }))
    end
end

-- Cycle through workspaces. Uses Hyprland's native e+1 / e-1 dispatch.
function ws.cycle(direction)
    if direction == "next" then
        hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
    else
        hl.dispatch(hl.dsp.focus({ workspace = "e-1" }))
    end
end

return ws
