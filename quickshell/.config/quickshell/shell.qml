import Quickshell
// import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// import "./config.js" as Config

ShellRoot {
    // for each screens
    Variants {
        model: Quickshell.screens

        // bar
        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            color: "transparent" // Config.colors.background

            Item {
                anchors.centerIn: parent
                width: 1280
                height: parent.height

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14

                    WorkspaceBar {
                        screenName: modelData.name
                    }

                    // spacer
                    Item {
                        Layout.fillWidth: true
                    }

                    BatteryBar {}
                    Item { Layout.preferredWidth: 2.5 }
                    DateBar {}
                }
            }
        }
    }
}
