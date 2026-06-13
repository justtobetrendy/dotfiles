#!/bin/bash
#
# ██████╗ ██╗ █████╗    ███████╗██╗  ██╗
# ██╔══██╗██║██╔══██╗   ██╔════╝██║  ██║
# ██████╔╝██║███████║   ███████╗███████║
# ██╔═══╝ ██║██╔══██║   ╚════██║██╔══██║
# ██║     ██║██║  ██║██╗███████║██║  ██║
# ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝
#
# source: 
# description: script to toggle PIA vpn connection it also allows connection to a predefined list of regions.
# requires: notify-send, piactl (official pia app)
# usage: pia.sh [toggle | select-region]
#
                                      
CMD=$1
CONNECTED=Connected
DISCONNECTED=Disconnected

# possible states
# Disconnected, Connecting, Connected, Interrupted, Reconnecting, DisconnectingToReconnect, Disconnecting

connection_state=$(piactl get connectionstate)
connection_region=$(piactl get region)

# Toggling between connection and disconnection
if [ "$CMD" = "toggle" ]; then
    if [ "$connection_state" = "Connected" ]; then
        notify-send 'Private Internet Access' "disconnecting..."
        $(piactl disconnect)
    elif [ "$connection_state" = "Disconnected" ]; then
        notify-send 'Private Internet Access' "connecting..."
        $(piactl connect)
    fi

    connection_state=$(piactl get connectionstate)
fi

# Region connection
if [ "$CMD" = "select-region" ]; then
    region=$(piactl get regions | rofi -dmenu -theme ~/.config/rofi/menu-searchable/style.rasi)

    if [ "$region" != "" ]; then
        $(piactl set region $region)
        connection_state=$(piactl get connectionstate)
    fi
fi

# Adding custom connection state when connected to a stream optimized node
if [[ "$connection_region" == *"streaming-optimized"* ]]; then
    if [ "$connection_state" = "Connected" ]; then
        connection_state=ConnectedStreaming
    fi
fi

# Formating region

# 1-Replace underscores with spaces
spaced="${connection_region//-/ }"

# 2-Split the sentence into an array (IFS = space)
IFS=' ' read -r -a words <<< "$spaced"

# 3-First word as uppercase if length == 2, elsewise Title case
first="${words[0]}"
if (( ${#first} == 2 )); then
    # Exactly two characters → all‑caps
    words[0]="${first^^}"
else
    # Otherwise title‑case (first letter ↑)
    words[0]="${first^}"
fi

# 4-Title‑case the rest of the words
for i in "${!words[@]}"; do
    (( i == 0 )) && continue          # skip the first word (already handled)
    w="${words[i]}"
    words[i]="${w^}"                  # first letter ↑, rest unchanged
done

# 5-Re‑assemble the array into a single string
connected_region_sanitized="${words[*]}"

# Output json
echo "{\"alt\": \"$connection_state\", \"text\": \"$connected_region_sanitized\"}"
