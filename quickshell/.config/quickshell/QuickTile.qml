import QtQuick
import QtQuick.Controls.Basic
import "./config.js" as Config

AbstractButton {
    id: root

    property string glyph: ""
    property string label: ""
    property bool active: false

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: 40
    padding: 12
    leftPadding: 5

    Accessible.name: root.label

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    contentItem: Row {
        spacing: 5

        Rectangle {
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter
            radius: root.active ? 8 : 14
            color: root.active ? Config.colors.tile.badgeActive : Config.colors.tile.badgeInactive

            Text {
                anchors.centerIn: parent
                text: root.glyph
                color: Config.colors.on_background
                font {
                    family: Config.bar.fontFamily
                    pixelSize: Config.bar.fontSize + 3
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            color: Config.colors.on_background
            font {
                family: Config.bar.fontFamily
                pixelSize: Config.bar.fontSize - 3
            }
        }
    }

    background: Rectangle {
        radius: 10
        color: Config.colors.tile.background
    }
}
