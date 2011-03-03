import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.ProgressBar {
    id:progressbar

    QStyleItem { id:buttonitem; elementType: "progressbar" }
    property int buttonWidth: buttonitem.sizeFromContents(25, 200).width
    property int buttonHeight: buttonitem.sizeFromContents(25, 200).height
    property int orientation: Qt.Horizontal
    height: orientation == Qt.Vertical ? buttonHeight : buttonWidth
    width: orientation == Qt.Vertical ? buttonWidth : buttonHeight

    background: QStyleBackground{
        anchors.fill:parent
        style: QStyleItem {
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
}

