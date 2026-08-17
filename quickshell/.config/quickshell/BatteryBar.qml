import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "./config.js" as Config

Rectangle {
    id: root

    color: Config.colors.background
    radius: 8
    implicitHeight: Config.bar.height
    implicitWidth: iconText.implicitWidth + 6 + (hasBattery ? pctText.implicitWidth : 0) + 20

    readonly property real pct: UPower.displayDevice?.percentage ?? -1
    readonly property bool hasBattery: pct >= 0
    readonly property bool plugged: UPower.displayDevice?.state === UPowerDeviceState.Charging
        || UPower.displayDevice?.state === UPowerDeviceState.FullyCharged
        || UPower.displayDevice?.state === UPowerDeviceState.PendingCharge

    function batteryIcon(level: real) : string {
        if (level >= 90) return "";
        if (level >= 60) return "";
        if (level >= 30) return "";
        if (level >= 10) return "";
        return "";
    }

    Text {
        id: iconText
        x: 10
        anchors.verticalCenter: parent.verticalCenter
        text: plugged ? "" : batteryIcon(pct * 100)
        color: Config.colors.on_background
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.fontSize
        }
    }

    Text {
        id: pctText
        x: iconText.x + iconText.implicitWidth + 6
        anchors.verticalCenter: parent.verticalCenter
        text: hasBattery ? Math.round(pct * 100) + "%" : ""
        visible: hasBattery
        color: Config.colors.on_background
        font {
            family: Config.bar.fontFamily
            pixelSize: Config.bar.fontSize
            weight: Config.bar.fontWeight
        }
    }
}