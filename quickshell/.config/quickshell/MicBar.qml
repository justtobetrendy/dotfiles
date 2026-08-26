import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "./config.js" as Config

Rectangle {
    id: root

    color: Config.colors.background
    radius: 8
    implicitHeight: Config.bar.height
    implicitWidth: 30

    readonly property bool muted: Pipewire.defaultAudioSource?.audio?.muted ?? true
    readonly property real volume: Pipewire.defaultAudioSource?.audio?.volume ?? 0
    readonly property bool wantsPopup: barHover.hovered || popupHover.hovered

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }

    Text {
        id: iconText
        anchors.centerIn: parent
        text: root.muted ? "\u{f036d}" : "\u{f036c}"
        color: Config.colors.on_background
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.singleIconFontSize + 1
            weight: Font.Normal
        }
    }

    Timer {
        interval: 500
        running: root.wantsPopup && !popup.visible
        onTriggered: popup.visible = true
    }

    Timer {
        interval: 300
        running: !root.wantsPopup && popup.visible
        onTriggered: popup.visible = false
    }

    Process {
        id: wiremixProc
        command: ["ghostty", "--class=com.Wiremix", "-e", "wiremix", "--tab", "input"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                wiremixProc.startDetached();
            } else {
                if (Pipewire.defaultAudioSource?.audio)
                    Pipewire.defaultAudioSource.audio.muted = !root.muted;
            }
        }
    }

    HoverHandler {
        id: barHover
    }

    PopupWindow {
        id: popup
        grabFocus: false
        visible: false
        implicitWidth: 40
        implicitHeight: 140
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
                    text: iconText.text
                    color: iconText.color
                    Layout.alignment: Qt.AlignHCenter
                    font {
                        family: Config.bar.fontFamily
                        pixelSize: 12
                    }
                }

                Slider {
                    id: slider
                    orientation: Qt.Vertical
                    from: 0
                    to: 1
                    stepSize: 0.01
                    value: root.volume
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onMoved: {
                        if (Pipewire.defaultAudioSource?.audio)
                            Pipewire.defaultAudioSource.audio.volume = value;
                    }
                    background: Rectangle {
                        x: slider.leftPadding + slider.availableWidth / 2 - width / 2
                        y: slider.topPadding
                        width: 4
                        height: slider.availableHeight
                        radius: 2
                        color: Config.colors.slider.background
                        Rectangle {
                            x: 0
                            y: parent.height * slider.visualPosition
                            width: parent.width
                            height: parent.height * (1 - slider.visualPosition)
                            radius: 2
                            color: Config.colors.slider.fill
                        }
                    }
                    handle: Rectangle {
                        x: slider.leftPadding + slider.availableWidth / 2 - width / 2
                        y: slider.topPadding + slider.visualPosition * (slider.availableHeight - height)
                        width: 12
                        height: 4
                        radius: 2
                        color: Config.colors.slider.handle
                    }
                }

                Text {
                    horizontalAlignment: Text.AlignHCenter
                    text: Math.round(root.volume * 100) + "%"
                    color: Config.colors.slider.background
                    Layout.fillWidth: true
                    font {
                        family: Config.bar.fontFamily
                        pixelSize: 11
                    }
                }
            }

            HoverHandler {
                id: popupHover
            }
        }
    }
}
