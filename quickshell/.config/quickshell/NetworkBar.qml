import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./config.js" as Config

Rectangle {
    id: root

    property bool isConnected: false
    property bool isWifi: false
    property bool foundConnected: false
    property bool foundWifi: false

    color: Config.colors.background
    radius: 8
    implicitHeight: Config.bar.height
    implicitWidth: 30

    function updateState() {
        debounce.restart();
    }

    Component.onCompleted: updateState()

    Timer {
        id: debounce
        interval: 1000
        onTriggered: statusProc.running = true;
    }

    Text {
        anchors.centerIn: parent
        text: {
            if (!root.isConnected)
                return "󰅗";
            if (root.isWifi)
                return "󰖩";
            return "󰈀";
        }
        color: root.isConnected ? Config.colors.on_background : Config.colors.danger
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.fontSize
            weight: Config.bar.fontWeight
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                ghosttyProc.startDetached();
            }
        }
    }

    Process {
        id: statusProc
        command: ["networkctl", "list", "--no-pager", "--no-legend"]
        onRunningChanged: {
            if (running) {
                root.foundConnected = false;
                root.foundWifi = false;
            } else {
                root.isConnected = root.foundConnected;
                root.isWifi = root.foundWifi;
            }
        }
        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                if (!line || !line.includes("routable"))
                    return;
                root.foundConnected = true;
                if (line.includes("wlan"))
                    root.foundWifi = true;
            }
        }
    }

    Process {
        id: monitorProc
        command: ["sh", "-c", "ip monitor link & ip monitor route & wait"]
        running: true
        stdout: SplitParser {
            onRead: data => updateState()
        }
        onRunningChanged: if (!running) running = true
    }

    Process {
        id: ghosttyProc
        command: ["ghostty", "--class=com.Impala", "-e", "impala"]
    }
}
