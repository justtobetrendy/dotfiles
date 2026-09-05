import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "./config.js" as Config

RowLayout {
    id: root

    required property string screenName

    spacing: 2

    Repeater {
        model: {
            const cfg = Config.screens[screenName];
            if (!cfg)
                return [];
            const list = [];
            for (let i = cfg.start; i <= cfg.end; i++)
                list.push(i);
            return list;
        }

        Item {
            required property int modelData
            readonly property bool isActive: Hyprland.focusedWorkspace?.id === modelData

            width: 24
            height: 10

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                x: (parent.width - width) / 2 + 1
                width: parent.isActive ? 24 : 10
                height: 10
                radius: height / 2
                color: "white"

                Behavior on width {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData + " })")
            }
        }
    }
}
