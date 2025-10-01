#!/usr/bin/fish

# Usage: ws <target_workspace_id>

if test (count $argv) -gt 0
    set target_ws $argv[1]
else
    echo "No target workspace provided"
    exit 1
end

set current_ws (hyprctl activeworkspace -j | jq -r '.id')

# Initialize HYPR_LAST_WS if not set
if not set -q HYPR_LAST_WS
    set -U HYPR_LAST_WS $current_ws
end

echo "Switching from $current_ws to $target_ws (last: $HYPR_LAST_WS)"

if test "$current_ws" = "$target_ws"
    # Toggle back to previous workspace
    hyprctl dispatch workspace $HYPR_LAST_WS
else
    # Store the current workspace as the last one
    set -U HYPR_LAST_WS $current_ws
    hyprctl dispatch workspace $target_ws
end
