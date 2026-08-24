import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "./config.js" as Config

Rectangle {
    id: root

    signal closeRequested

    required property QtObject powerService
    required property QtObject filterService
    required property QtObject updateService

    readonly property bool hovered: panelHover.hovered

    implicitWidth: 300
    implicitHeight: grid.implicitHeight + 20

    color: Config.colors.background
    radius: 4

    GridLayout {
        id: grid

        anchors.fill: parent
        anchors.margins: 10
        columns: 2
        rowSpacing: 10
        columnSpacing: 10

        UpdateStatTile {
            Layout.fillWidth: true

            label: "arch"
            count: root.updateService.archUpdates
        }

        UpdateStatTile {
            Layout.fillWidth: true

            label: "aur"
            count: root.updateService.aurUpdates
        }

        QuickTile {
            Layout.fillWidth: true

            glyph: root.powerService.icons[root.powerService.currentProfile] ?? root.powerService.icons.balanced
            label: root.powerService.labels[root.powerService.currentProfile] ?? root.powerService.labels.balanced
            active: true
            onClicked: root.powerService.cycleProfile()
        }

        QuickTile {
            Layout.fillWidth: true

            glyph: "\u{F293}"
            label: "Bluetooth"
            active: true
            onClicked: {
                blueberryProc.startDetached();
                root.closeRequested();
            }
        }

        QuickTile {
            Layout.fillWidth: true

            glyph: root.filterService.icon
            label: "Night light"
            active: root.filterService.enabled
            onClicked: root.filterService.toggle()
        }

        Item {
            Layout.fillWidth: true
        }
    }

    Process {
        id: blueberryProc

        command: ["blueberry"]
    }

    HoverHandler {
        id: panelHover
    }
}
