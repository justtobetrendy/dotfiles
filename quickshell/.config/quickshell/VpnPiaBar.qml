import QtQuick
import QtQuick.Layouts
import Quickshell
import "./config.js" as Config

Rectangle {
    id: root

    required property QtObject service

    color: Config.colors.background
    radius: 8
    implicitHeight: Config.bar.height
    implicitWidth: 30

    readonly property string formattedRegion: service.formatRegionName(service.currentRegion)

    Text {
        anchors.centerIn: parent
        // text: service.isConnected ? "\u{f0498}" : "\u{f099e}"
        text: service.isConnected ? "\u{f0498}" : service.isTransitioning ? "\u{f11a2}" : "\u{f099e}"
        color: service.isConnected ? Config.colors.success : service.isTransitioning ? Config.colors.warning : Config.colors.danger
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.singleIconFontSize
            weight: Config.bar.fontWeight
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                service.toggleConnection();
            } else if (mouse.button === Qt.RightButton) {
                service.refreshCurrentRegion();
                popup.visible = !popup.visible;
            }
        }
    }

    PopupWindow {
        id: popup
        grabFocus: true
        visible: false
        implicitWidth: 200
        implicitHeight: 300
        color: "transparent"
        anchor {
            item: root
            rect.x: (root.width - popup.width) / 2
            rect.y: root.height + 4
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: Config.colors.background

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Text {
                    text: qsTr("Region")
                    color: Config.colors.on_background
                    Layout.fillWidth: true
                    font {
                        family: Config.bar.fontFamily
                        pixelSize: 12
                        weight: Config.bar.fontWeight
                    }
                }

                Text {
                    text: root.formattedRegion
                    color: Config.colors.region_selected
                    Layout.fillWidth: true
                    font {
                        family: Config.bar.fontFamily
                        pixelSize: 11
                    }
                }

                Rectangle {
                    color: Config.colors.on_background
                    opacity: 0.2
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                }

                ListView {
                    id: regionList
                    clip: true
                    model: service.regions
                    spacing: 2
                    delegate: regionDelegate
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Component {
                        id: regionDelegate

                        Rectangle {
                            required property string modelData
                            width: regionList.width
                            height: 24
                            radius: 4
                            color: modelData === service.currentRegion ? Config.colors.region_selected : "transparent"

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                text: service.formatRegionName(modelData)
                                color: modelData === service.currentRegion ? Config.colors.background : Config.colors.on_background
                                font {
                                    family: Config.bar.fontFamily
                                    pixelSize: 11
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    service.setRegion(modelData);
                                    popup.visible = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
