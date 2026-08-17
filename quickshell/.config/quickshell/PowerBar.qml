import QtQuick
import Quickshell.Io
import "./config.js" as Config

Item {
    id: root

    implicitHeight: Config.bar.height
    implicitWidth: 30

    Text {
        anchors.centerIn: parent
        text: "\u{F011}"
        color: Config.colors.on_background
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.fontSize + 1
            weight: Config.bar.fontWeight // TODO: does not seem to work on nerd font icons
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: proc.startDetached()
    }

    Process {
        id: proc
        command: ["sh", "-c", "lua ~/.config/hypr/scripts/powermenu.lua"]
    }
}
