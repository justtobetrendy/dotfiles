import QtQuick
import Quickshell.Io

Item {
    id: root

    property int archUpdates: 0
    property int aurUpdates: 0

    function refresh() {
        checkupdatesProc.running = true;
        aurProc.running = true;
    }

    visible: false

    Component.onCompleted: refresh()

    Timer {
        interval: 3600000 // 1 hour
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: root.refresh()
    }

    Process {
        id: checkupdatesProc

        command: ["sh", "-c", "checkupdates | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: root.archUpdates = parseInt(this.text) || 0
        }
    }

    Process {
        id: aurProc

        command: ["sh", "-c", "paru -Qua | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: root.aurUpdates = parseInt(this.text) || 0
        }
    }
}
