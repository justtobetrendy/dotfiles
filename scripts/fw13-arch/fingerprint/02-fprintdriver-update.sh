#!/bin/bash
GUID=$(fwupdmgr get-devices | grep -A 6 -E "fingerprint" | grep -i "GUID" | awk -F ': ' '{print $2}' | awk '{print $1}'); clear && echo "fwupdmgr get-devices $GUID" && fwupdmgr get-updates $GUID
