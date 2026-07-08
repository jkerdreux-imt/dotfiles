#!/bin/bash
# for keyd-virtual-keyboard only

keyd_kb="keyd-virtual-keyboard"
keyd_switch="/usr/local/bin/keyd-switch.sh"

# Exit immediately if keyd-switch.sh is missing or not executable
if [[ ! -x "$keyd_switch" ]]; then
    echo "❌ Error: $keyd_switch not found or not executable. Exiting."
    exit 1
fi

# Get current layout
current_layout=$(hyprctl devices -j | jq -r ".keyboards[] | select(.name==\"$keyd_kb\") | .active_keymap")

if [[ "$current_layout" == *"English"* ]]; then
    new_layout="fr"
else
    new_layout="us"
fi

# Apply new layout
if [[ "$new_layout" == "fr" ]]; then
    echo "→ Switching to 🇫🇷 French (AZERTY)"
    sudo "$keyd_switch" internal
    setxkbmap fr 2>/dev/null
    # hyprctl keyword input:kb_variant "" >/dev/null
    # hyprctl keyword input:kb_layout fr >/dev/null
    hyprctl switchxkblayout all 1
    notify-send "Keyboard" "🇫🇷 AZERTY (keyd active)"
else
    echo "→ Switching to 🇺🇸 English (US intl)"
    sudo "$keyd_switch" alice
    setxkbmap us intl 2>/dev/null
    # hyprctl keyword input:kb_layout "us" >/dev/null
    # hyprctl keyword input:kb_variant "intl" >/dev/null
    hyprctl switchxkblayout all 0
    notify-send "Keyboard" "🇺🇸 QWERTY (keyd active)"
fi

# Force refresh for the keyd virtual keyboard
# hyprctl switchxkblayout "$keyd_kb" next >/dev/null 2>&1

echo "✅ Layout switched to $new_layout"
