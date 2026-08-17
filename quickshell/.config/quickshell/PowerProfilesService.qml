import QtQuick
import Quickshell.Io

Item {
    id: root

    property string currentProfile: "balanced"
    readonly property var profiles: ["performance", "balanced", "power-saver"]
    readonly property var icons: ({
            performance: "",
            balanced: "",
            "power-saver": ""
        })

    readonly property var labels: ({
            performance: "Performance",
            balanced: "Balanced",
            "power-saver": "Power saver"
        })

    visible: false

    function cycleProfile() {
        const index = profiles.indexOf(currentProfile);
        setProfile(profiles[(index + 1) % profiles.length]);
    }

    function setProfile(profile) {
        root.currentProfile = profile;
        setProc.command = ["powerprofilesctl", "set", profile];
        setProc.startDetached();
    }

    function refreshProfile() {
        fetchProfileProc.running = true;
    }

    Component.onCompleted: refreshProfile()

    Process {
        id: fetchProfileProc
        command: ["powerprofilesctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                const trimmed = this.text.trim();
                if (trimmed)
                    root.currentProfile = trimmed;
            }
        }
    }

    Process {
        id: setProc
        command: ["powerprofilesctl", "set", "balanced"]
        stdout: StdioCollector {
            onStreamFinished: root.refreshProfile()
        }
    }
}
