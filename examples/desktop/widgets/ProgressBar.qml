import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.ProgressBar {
    id:progressbar

    // Align with button
    property int buttonHeight: buttonitem.sizeFromContents(100, 15).height
    QStyleItem { id:buttonitem; elementType:"button" }
    height: buttonHeight

    background: QStyleBackground{
        anchors.fill:parent
        style: QStyleItem{
            elementType:"progressbar"
            minimum: minimumValue
            maximum: maximumValue
            value:   progressbar.value
            enabled: progressbar.enabled
        }
    }

    progress: Item{}
}

