import QtQuick
import QtQuick.Layouts
import "./config.js" as Config

Item {
    id: root

    property bool fill: false
    property real size: Config.bar.spacing

    Layout.preferredWidth: fill ? -1 : size
    Layout.fillWidth: fill
}
