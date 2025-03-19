#!/usr/bin/fish

if test (count $argv) >0
    set target_ws $argv[1]
else
    echo "No target workspace provided"
    exit 1
end

set current_ws (hyprctl activeworkspace -j |jq -r '.id')

set -q HYPR_LAST_WS || set -U HYPR_LAST_WS 1

echo "Switching from $current_ws to $target_ws ($HYPR_LAST_WS)"

if test "$current_ws" = "$target_ws"
    # Retour au workspace précédent
    hyprctl dispatch workspace $HYPR_LAST_WS
else
    # Stocker l'ID du workspace actuel dans HYPR_PREV_WS
    set -U HYPR_LAST_WS "$current_ws"
    hyprctl dispatch workspace $target_ws
end
