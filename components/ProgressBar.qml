import QtQuick 1.1
import "custom" as Components

Components.ProgressBar {
    id:progressbar

    property int orientation: Qt.Horizontal
    property string styleHint

    implicitWidth: orientation === Qt.Horizontal ? 200 : backgroundItem.implicitHeight
    implicitHeight: orientation === Qt.Horizontal ? backgroundItem.implicitHeight : 200


    SystemPalette {id: syspal}

    background: StyleItem {
        anchors.fill: parent
        elementType: "progressbar"
        // XXX: since desktop uses int instead of real, the progressbar
        // range [0..1] must be stretched to a good precision
        property int factor : 1000
        value:   indeterminate ? 0 : progressbar.value * factor // does indeterminate value need to be 1 on windows?
        minimum: indeterminate ? 0 : progressbar.minimumValue * factor
        maximum: indeterminate ? 0 : progressbar.maximumValue * factor
        enabled: progressbar.enabled
        horizontal: progressbar.orientation == Qt.Horizontal
        hint: progressbar.styleHint
        contentWidth: 23
        contentHeight: 23
    }
}

