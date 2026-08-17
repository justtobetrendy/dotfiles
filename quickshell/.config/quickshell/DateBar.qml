import QtQuick
import Quickshell
import "./config.js" as Config

Rectangle {
    id: root

    color: Config.colors.background
    radius: 8
    implicitHeight: Config.bar.height
    implicitWidth: clockText.implicitWidth + 20

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: clockText
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, "hh:mm 󰸘 dd")
        color: Config.colors.on_background

        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.fontSize
            weight: Config.bar.fontWeight
        }
    }
}