import QtQuick
import Quickshell.Io
import "./config.js" as Config

Item {
    id: root

    property bool enabled: false
    readonly property string icon: "\u{F186}"

    readonly property int offTemperature: 6500
    readonly property int activeThreshold: 5000

    visible: false

    function toggle() {
        setProc.command = ["hyprctl", "hyprsunset", "temperature", root.enabled ? String(root.offTemperature) : String(Config.bluelight.temperature)];
        setProc.running = true;
    }

    function refresh() {
        queryProc.running = true;
    }

    Component.onCompleted: refresh()

    Process {
        id: queryProc

        command: ["hyprctl", "hyprsunset", "temperature"]
        stdout: StdioCollector {
            onStreamFinished: {
                const temperature = parseInt(this.text.trim());
                if (!isNaN(temperature))
                    root.enabled = temperature < root.activeThreshold;
            }
        }
    }

    Process {
        id: setProc

        stdout: StdioCollector {
            onStreamFinished: root.refresh()
        }
    }
}
