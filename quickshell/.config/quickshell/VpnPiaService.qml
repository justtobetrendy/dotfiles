import QtQuick
import Quickshell.Io

Item {
    id: root

    property string connectionState: "Disconnected"
    property var regions: []
    property string currentRegion: "auto"

    readonly property bool isConnected: connectionState === "Connected"
    readonly property bool isTransitioning: connectionState === "Connecting" || connectionState === "Reconnecting"

    visible: false

    function notify(message) {
        notifyProc.command = ["notify-send", "-u", "normal", "-t", "3000", qsTr("VPN"), message];
        notifyProc.startDetached();
    }

    function formatRegionName(id) {
        if (id === "auto")
            return "Auto";
        const words = id.split("-");
        const result = [];
        for (const w of words) {
            if (w === "streaming") {
                result.push("(streaming)");
            } else if (w === "optimized") {
                continue;
            } else if (w.length === 2) {
                result.push(w.toUpperCase());
            } else {
                result.push(w.charAt(0).toUpperCase() + w.slice(1));
            }
        }
        return result.join(" ");
    }

    function toggleConnection() {
        toggleProc.command = root.isConnected ? ["piactl", "disconnect"] : ["piactl", "connect"];
        toggleProc.startDetached();
    }

    function refreshCurrentRegion() {
        fetchCurrentRegionProc.running = true;
    }

    function setRegion(region) {
        setRegionProc.command = ["piactl", "set", "region", region];
        setRegionProc.startDetached();
        root.currentRegion = region;
    }

    onConnectionStateChanged: {
        if (connectionState === "Connected" || connectionState === "Disconnected")
            notify(qsTr("%1 - %2").arg(connectionState).arg(formatRegionName(currentRegion)));
    }

    Component.onCompleted: refreshCurrentRegion()

    Process {
        id: monitorProc
        command: ["piactl", "monitor", "connectionstate"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const trimmed = data.trim();
                if (trimmed)
                    root.connectionState = trimmed;
            }
        }
        onRunningChanged: if (!running)
            running = true
    }

    Process {
        id: toggleProc
        command: ["piactl", "disconnect"]
    }

    Process {
        id: notifyProc
        command: ["notify-send"]
    }

    Process {
        id: fetchRegionsProc
        command: ["piactl", "get", "regions"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n").filter(l => l.trim());
                const isCa = r => r === "ca" || r.startsWith("ca-");
                const isUs = r => r === "us" || r.startsWith("us-");
                lines.sort((a, b) => {
                    if (a === "auto")
                        return -1;
                    if (b === "auto")
                        return 1;
                    const aCa = isCa(a), bCa = isCa(b);
                    const aUs = isUs(a), bUs = isUs(b);
                    if (aCa !== bCa)
                        return aCa ? -1 : 1;
                    if (aUs !== bUs)
                        return aUs ? -1 : 1;
                    return a.localeCompare(b);
                });
                root.regions = lines;
            }
        }
    }

    Process {
        id: fetchCurrentRegionProc
        command: ["piactl", "get", "region"]
        stdout: StdioCollector {
            onStreamFinished: {
                const trimmed = this.text.trim();
                if (trimmed)
                    root.currentRegion = trimmed;
            }
        }
    }

    Process {
        id: setRegionProc
        command: ["piactl", "set", "region", "auto"]
    }
}
