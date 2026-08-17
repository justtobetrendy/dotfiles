import QtQuick
import Quickshell
import "./config.js" as Config

Rectangle {
    id: root

    required property QtObject powerService
    required property QtObject filterService

    readonly property bool wantsPopup: barHover.hovered || panelContent.hovered

    color: Config.colors.background
    radius: 8
    implicitHeight: Config.bar.height
    implicitWidth: archIcon.implicitWidth + btwText.implicitWidth + 20

    Text {
        id: archIcon
        x: 8
        anchors.verticalCenter: parent.verticalCenter
        text: "\u{F303}"
        color: Config.colors.on_background
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.fontSize
            weight: Config.bar.fontWeight
        }
    }

    Text {
        id: btwText
        x: archIcon.x + archIcon.implicitWidth + 4
        anchors.verticalCenter: parent.verticalCenter
        text: "btw"
        color: Config.colors.on_background
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.fontSize
            weight: Config.bar.fontWeight
        }
    }

    Timer {
        interval: 500
        running: root.wantsPopup && !panel.visible
        onTriggered: panel.visible = true
    }

    Timer {
        interval: 300
        running: !root.wantsPopup && panel.visible
        onTriggered: panel.visible = false
    }

    HoverHandler {
        id: barHover
    }

    PopupWindow {
        id: panel

        visible: false
        grabFocus: false
        implicitWidth: panelContent.implicitWidth
        implicitHeight: panelContent.implicitHeight
        color: "transparent"
        anchor {
            item: root
            rect.x: 0
            rect.y: root.height + 4
        }

        ArchPanel {
            id: panelContent

            powerService: root.powerService
            filterService: root.filterService
            onCloseRequested: panel.visible = false
        }
    }
}
