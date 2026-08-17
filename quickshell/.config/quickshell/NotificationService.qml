import Quickshell
// import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "./config.js" as Config

Scope {
    id: root
    property bool centerOpen: false
    readonly property int historyCount: history.count

    function toggleCenter(): void {
        centerOpen = !centerOpen;
    }

    ListModel {
        id: history
        dynamicRoles: false
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            history.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            n.tracked = true;
        }
    }

    // UNUSED FOR NOW, activate for external use
    // IpcHandler {
    //     target: "notifications"
    //     function toggle(): void {
    //         root.toggleCenter();
    //     }
    //     function show(): void {
    //         root.centerOpen = true;
    //     }
    //     function hide(): void {
    //         root.centerOpen = false;
    //     }
    // }

    // notification card
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: Config.notifications.timeout
                        onTriggered: card.modelData.dismiss()
                    }

                    Layout.fillWidth: true
                    implicitHeight: layout.implicitHeight + 20
                    Layout.preferredHeight: implicitHeight
                    radius: 8
                    color: Config.colors.notification.bg
                    border.width: 2
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Config.colors.notification.red : Config.colors.notification.purple

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            // title
                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: Config.colors.notification.cyan
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            // body
                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: Config.colors.notification.fg
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 1
                                wrapMode: Text.WordWrap
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 20
                            Layout.preferredHeight: 20
                            Layout.alignment: Qt.AlignTop
                            radius: 4
                            color: "transparent"
                            border.width: 1
                            // border.color: Config.colors.notification.red
                            border.color: Config.colors.notification.muted

                            Text {
                                anchors.centerIn: parent
                                text: "x"
                                // color: Config.colors.notification.red
                                color: Config.colors.notification.muted
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 1
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: card.modelData.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }

    // notification center
    PanelWindow {
        visible: root.centerOpen
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: centerCol.implicitHeight + 24
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: Config.colors.notification.bg
            border.width: 2
            border.color: Config.colors.notification.purple

            ColumnLayout {
                id: centerCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: Config.colors.notification.cyan
                        font.family: Config.bar.fontFamily
                        font.pixelSize: Config.bar.fontSize + 2
                        font.bold: true
                    }

                    // close
                    Text {
                        horizontalAlignment: Text.AlignRight
                        text: "Close"
                        color: Config.colors.notification.muted
                        font.family: Config.bar.fontFamily
                        font.pixelSize: Config.bar.fontSize - 1
                        font.bold: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.centerOpen = false
                        }
                    }

                    // close as x button
                    // Rectangle {
                    //     Layout.preferredWidth: 20
                    //     Layout.preferredHeight: 20
                    //     radius: 4
                    //     color: "transparent"
                    //     border.width: 1
                    //     border.color: Config.colors.notification.muted
                    //
                    //     Text {
                    //         anchors.centerIn: parent
                    //         text: "x"
                    //         color: Config.colors.notification.muted
                    //         font.family: Config.bar.fontFamily
                    //         font.pixelSize: Config.bar.fontSize - 1
                    //         font.bold: true
                    //     }
                    //
                    //     MouseArea {
                    //         anchors.fill: parent
                    //         cursorShape: Qt.PointingHandCursor
                    //         onClicked: root.centerOpen = false
                    //     }
                    // }
                }

                Text {
                    Layout.fillWidth: true
                    visible: history.count === 0
                    text: "No notifications"
                    color: Config.colors.notification.fg
                    font.family: Config.bar.fontFamily
                    font.pixelSize: Config.bar.fontSize - 1
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, 420)
                    Layout.maximumHeight: 420
                    visible: history.count > 0
                    spacing: 8
                    clip: true
                    model: history

                    delegate: Rectangle {
                        required property int index
                        required property string summary
                        required property string body
                        required property string appName
                        required property int urgency
                        required property string time

                        width: ListView.view.width
                        implicitHeight: centerCardLayout.implicitHeight + 20
                        radius: 8
                        color: Config.colors.notification.bg
                        border.width: 2
                        border.color: urgency === NotificationUrgency.Critical ? Config.colors.notification.red : Config.colors.notification.purple

                        ColumnLayout {
                            id: centerCardLayout
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 4

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    Layout.fillWidth: true
                                    text: summary
                                    // color: Config.colors.notification.cyan
                                    color: Config.colors.notification.fg
                                    font.family: Config.bar.fontFamily
                                    font.pixelSize: Config.bar.fontSize
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Rectangle {
                                    Layout.preferredWidth: 20
                                    Layout.preferredHeight: 20
                                    radius: 4
                                    color: "transparent"
                                    border.width: 1
                                    // border.color: Config.colors.notification.red
                                    border.color: Config.colors.notification.muted

                                    Text {
                                        anchors.centerIn: parent
                                        text: "x"
                                        // color: Config.colors.notification.red
                                        color: Config.colors.notification.muted
                                        font.family: Config.bar.fontFamily
                                        font.pixelSize: Config.bar.fontSize - 1
                                        font.bold: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: history.remove(index, 1)
                                    }
                                }
                            }

                            Text {
                                id: bodyText
                                Layout.fillWidth: true
                                visible: body !== ""
                                text: body
                                color: Config.colors.notification.fg
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 1
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                Layout.fillWidth: true
                                text: appName + " - " + time
                                color: Config.colors.notification.muted
                                opacity: 0.75
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 2
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignRight
                    visible: history.count > 0
                    text: "Clear all"
                    color: Config.colors.notification.red
                    font.family: Config.bar.fontFamily
                    font.pixelSize: Config.bar.fontSize - 1

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            history.clear();
                            root.centerOpen = false;
                        }
                    }
                }
            }
        }
    }
}
