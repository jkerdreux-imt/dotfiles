#!/bin/zsh

# Check usage and presence of arguments
if [[ -z "$1" ]]; then
  echo "Usage: $0 <prev|next>"
  return 1
fi

direction="$1"

# Check the validity of the argument
if [[ "$direction" != "prev" && "$direction" != "next" ]]; then
  echo "Error: Argument must be 'prev' or 'next'."
  return 1
fi

switch_workspace () {
  # Get the ID of the active workspace
  current_workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')

  # Get the list of all workspaces and count them
  total_workspaces=$(hyprctl workspaces -j| jq 'length')

  echo "Switch to $directiion from $current_workspace_id / $total_workspaces"
  # Calculate the ID of the target workspace
  local target_workspace_id
  if [[ "$direction" == "next" ]]; then
    if [[ "$current_workspace_id" -lt "$total_workspaces" ]]; then
      target_workspace_id=$((current_workspace_id + 1))
    else
      target_workspace_id=1
    fi
  elif [[ "$direction" == "prev" ]]; then
    if [[ "$current_workspace_id" -gt 1 ]]; then
      target_workspace_id=$((current_workspace_id - 1))
    else
      target_workspace_id="$total_workspaces"
    fi
  fi

  # Switch to the target workspace
  hyprctl dispatch workspace "$target_workspace_id"
}

# Call the switch_workspace function with the validated argument
switch_workspace

# Example of usage in your Hyprland configuration:
# bind = , $mod + Right, exec, ~/.config/hypr/switch-workspace.zsh next
# bind = , $mod + Left, exec, ~/.config/hypr/switch-workspace.zsh prev
