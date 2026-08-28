import QtQuick
import "./config.js" as Config

Rectangle {
    id: root

    property string label: ""
    property int count: 0

    signal clicked

    implicitWidth: column.implicitWidth + 20
    implicitHeight: 56
    radius: 10
    color: Config.colors.tile.background

    Accessible.role: Accessible.Button
    Accessible.name: root.label + ": " + root.count

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: root.clicked()
    }

    Column {
        id: column

        anchors.centerIn: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.count
            color: Config.colors.on_background
            font {
                family: Config.bar.fontFamily
                pixelSize: Config.bar.fontSize + 9
                weight: Font.Bold
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: Config.colors.muted
            font {
                family: Config.bar.fontFamily
                pixelSize: Config.bar.fontSize - 3
                weight: Config.bar.fontWeight
            }
        }
    }
}
