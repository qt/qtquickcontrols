import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.ProgressBar {
    id:progressbar

    property variant sizehint: backgroundItem.sizeFromContents(23, 23)
    property int orientation: Qt.Horizontal

    height: orientation === Qt.Horizontal ? sizehint.height : 200
    width: orientation === Qt.Horizontal ? 200 : sizehint.height

    background: QStyleItem {
        anchors.fill:parent
        elementType:"progressbar"
        // XXX: since desktop uses int instead of real, the progressbar
        // range [0..1] must be stretched to a good precision
        property int factor : 1000000
        value:   indeterminate ? 1 : progressbar.value * factor
        minimum: indeterminate ? 0 : progressbar.minimumValue * factor
        maximum: indeterminate ? 0 : progressbar.maximumValue * factor
        enabled: progressbar.enabled
        horizontal: progressbar.orientation == Qt.Horizontal

    }
}

