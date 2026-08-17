import QtQuick
import QtQuick.Layouts
import Quickshell
import "./config.js" as Config

ShellRoot {
    id: root

    VpnPiaService {
        id: vpnService
    }

    NotificationService {
        id: notificationService
    }

    PowerProfilesService {
        id: powerProfilesService
    }

    BlueLightFilterService {
        id: blueLightFilterService
    }

    // for each screens
    Variants {
        model: Quickshell.screens

        // bar
        PanelWindow {
            required property ShellScreen modelData
            screen: modelData
            implicitHeight: Config.bar.height
            color: "transparent" // Config.colors.background

            anchors {
                top: true
                left: true
                right: true
            }
            margins {
                top: 16
            }

            Item {
                anchors.centerIn: parent
                width: Config.bar.width
                height: parent.height

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 14
                    }

                    ArchBar {
                        powerService: powerProfilesService
                        filterService: blueLightFilterService
                    }

                    Spacer {}

                    WorkspaceBar {
                        screenName: modelData.name
                        Layout.fillWidth: false
                    }

                    Spacer {
                        fill: true
                    }

                    Spacer {}
                    VolumeBar {}
                    Spacer {}
                    MicBar {}
                    Spacer {}
                    VpnPiaBar {
                        service: vpnService
                    }
                    Spacer {}
                    NetworkBar {}
                    Spacer {}
                    BatteryBar {}
                    Spacer {}
                    DateBar {}
                    Spacer {}
                    NotificationBar {
                        service: notificationService
                    }
                    PowerBar {
                        Layout.leftMargin: 4
                    }
                }
            }
        }
    }
}
