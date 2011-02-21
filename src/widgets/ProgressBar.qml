import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.ProgressBar {
    id:progressbar

    // Align with button
    property int buttonHeight: buttonitem.sizeFromContents(100, 15).height
    QStyleItem { id:buttonitem; elementType:"button" }
    height: buttonHeight

    background: QStyleBackground{
        anchors.fill:parent
        style: QStyleItem {
            elementType:"progressbar"

            // XXX: since desktop uses int instead of real, the progressbar
            // range [0..1] must be stretched to a good precision
            property int factor : 1000000

            value:   progressbar.value * factor
            minimum: indeterminate ? 0 : progressbar.minimumValue * factor
            maximum: indeterminate ? 0 : progressbar.maximumValue * factor
            enabled: progressbar.enabled
        }
    }
    indeterminateProgress:null
    progress: null
}

