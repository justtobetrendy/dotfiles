import QtQuick
import "./config.js" as Config

Rectangle {
    id: root

    required property QtObject service

    readonly property bool hasNotifications: service.historyCount > 0

    color: Config.colors.background
    radius: 8
    implicitHeight: Config.bar.height
    implicitWidth: 30

    Text {
        anchors.centerIn: parent
        text: root.hasNotifications ? "\u{f009a}" : "\u{f009c}"
        color: Config.colors.on_background
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.singleIconFontSize
            weight: Config.bar.fontWeight
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.service.toggleCenter()
    }
}
