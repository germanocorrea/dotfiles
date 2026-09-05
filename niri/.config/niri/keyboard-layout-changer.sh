#!/usr/bin/env sh

USB_UUID="046d:c548" # logibolt
NIRI_KEYBOARD_LAYOUT_MAPPING=$(cat ~/.config/niri/window-keyboard-layouts.json)
DEFAULT_LAYOUT_IDX=$(echo "$NIRI_KEYBOARD_LAYOUT_MAPPING" | jq .default)
DEFAULT_USB_LAYOUT_IDX=$(echo "$NIRI_KEYBOARD_LAYOUT_MAPPING" | jq .default_usb)

debug() {
    echo "[NIRI KEYLAY WINDOW MANAGER]: $1" # | systemd-cat -p info
}

get_app_id_layout() {
    return $(echo "$NIRI_KEYBOARD_LAYOUT_MAPPING" | jq ".per_app_id_usb_only | .$1 // empty")
}

niri_switch_layout() {
    niri msg action switch-layout "$1"
}

set_layout_based_on_active_window() {
    debug "setting layout"
    USB_CONNECTED_INFO=$(lsusb -d "$USB_UUID")

    if [ -n "$USB_CONNECTED_INFO" ]; then # -n = USB_CONNECTED_INFO !empty

        debug "usb connected, checking focused app"
        APP_ID=$(niri msg -j focused-window | jq .app_id | tr -d '"')
        debug "current app id: $APP_ID"
        # APP_LAYOUT=$(get_app_id_layout "$APP_ID")
        APP_LAYOUT=$(echo "$NIRI_KEYBOARD_LAYOUT_MAPPING" | jq ".per_app_id_usb_only | .$APP_ID // empty")

        if [ -n "$APP_LAYOUT" ]; then # -n = APP_LAYOUT !empty

            debug "setting layout for $APP_ID: $APP_LAYOUT"
            niri_switch_layout "$APP_LAYOUT"

        else

            debug "no mapped app id, setting default $DEFAULT_USB_LAYOUT_IDX"
            niri_switch_layout "$DEFAULT_USB_LAYOUT_IDX"

        fi

    else
        debug "usb not connected, setting default layout $DEFAULT_LAYOUT_IDX"
        niri_switch_layout "$DEFAULT_LAYOUT_IDX"
    fi
}

set_layout_based_on_active_window # calls once to set layout initially
while true; do
    niri msg event-stream | grep -qe "active window changed"
    debug "recieved window focus change event"
    set_layout_based_on_active_window
done
