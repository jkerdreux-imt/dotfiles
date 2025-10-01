#!/bin/zsh

# Check usage and presence of arguments
if [[ -z "$1" ]]; then
  echo "Usage: $0 <prev|next>"
  exit 1
fi

direction="$1"

# Check the validity of the argument
if [[ "$direction" != "prev" && "$direction" != "next" ]]; then
  echo "Error: Argument must be 'prev' or 'next'."
  exit 1
fi

switch_workspace () {
  # Get the ID of the active workspace
  current_workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')

  # Count only normal (non-special) workspaces
  total_workspaces=$(hyprctl workspaces -j | jq '[.[] | select(.id > 0)] | length')

  echo "Switch to $direction from $current_workspace_id / $total_workspaces"

  # Calculate target workspace with modulo
  if [[ "$direction" == "next" ]]; then
    target_workspace_id=$(( (current_workspace_id % total_workspaces) + 1 ))
  else
    target_workspace_id=$(( ( (current_workspace_id - 2 + total_workspaces) % total_workspaces ) + 1 ))
  fi

  # Switch to the target workspace
  hyprctl dispatch workspace "$target_workspace_id"
}

# Call the switch_workspace function
switch_workspace
