#!/bin/bash
#
# ██╗  ██╗██╗   ██╗██████╗ ██████╗ ███████╗██╗   ██╗███╗   ██╗███████╗███████╗████████╗███████╗██╗  ██╗
# ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██║   ██║████╗  ██║██╔════╝██╔════╝╚══██╔══╝██╔════╝██║  ██║
# ███████║ ╚████╔╝ ██████╔╝██████╔╝███████╗██║   ██║██╔██╗ ██║███████╗█████╗     ██║   ███████╗███████║
# ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗╚════██║██║   ██║██║╚██╗██║╚════██║██╔══╝     ██║   ╚════██║██╔══██║
# ██║  ██║   ██║   ██║     ██║  ██║███████║╚██████╔╝██║ ╚████║███████║███████╗   ██║██╗███████║██║  ██║
# ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝   ╚═╝╚═╝╚══════╝╚═╝  ╚═╝
#
# source: https://gist.github.com/Dregu/ddba409a837ce87af8f9e26ef90f67e9
# description: scrip to toggle/set gamma and temperature via hyprsunset. modified from source; return type as json and added alt (modifiations made to accomodate waybar).
# requires: 
# 

CMD=$1
DELTA=$2
TOGGLE=$3

# if [ -z "$CMD" ]; then
#   echo "Set or get gamma and color temperature through hyprsunset IPC socket"
#   echo "Usage: sunset.sh <gamma/temperature> [+-][value] [toggle]"
#   exit 1
# fi

if [[ ! -z "$TOGGLE" ]]; then
  CUR=$(hyprctl hyprsunset $CMD)
  FMT=$(LC_NUMERIC="en_US.UTF-8" printf "%.0f" $CUR 2>/dev/null)
  if [ "$FMT" = "$DELTA" ]; then
    if [ "$CMD" = "gamma" ]; then
      DELTA=100
    else
      DELTA=6500
    fi
  fi
fi

[ "$CMD" = "gamma" ] && LEN=3 || LEN=4
if [[ ! -z "$DELTA" ]]; then
  # rate limit and queue commands to workaround nvidia freezing on ctm spam
  flock /tmp/sunset.lock sleep 0.1
  # tell waybar to update after a change
  pkill -SIGRTMIN+$LEN waybar
fi

if NUM=$(hyprctl hyprsunset $CMD $DELTA); then
  if FMT=$(LC_NUMERIC="en_US.UTF-8" printf "%$LEN.0f" $NUM 2>/dev/null); then
    # Determine the 'alt' property based on default values
    if [ "$CMD" = "gamma" ] && [ "$FMT" -eq 100 ]; then
      ALT="default"
    elif [ "$CMD" = "temperature" ] && [ "$FMT" -eq 6500 ]; then
      ALT="default"
    else
      ALT="custom"
    fi

    # Output JSON string
    echo "{\"percentage\": $FMT, \"alt\": \"$ALT\"}"
  fi
fi
