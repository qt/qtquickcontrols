import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

// jens: ContainsMouse breaks drag functionality

Components.Slider{
    id:slider
    minimumWidth:200

    // Align with button
    property int buttonHeight: buttonitem.sizeFromContents(100, 15).height
    QStyleItem { id:buttonitem; elementType:"button" }
    height: buttonHeight

    groove: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem{
            elementType:"slider"
            sunken: pressed
            maximum:slider.maximumValue
            minimum:slider.minimumValue
            value:slider.value
            horizontal:slider.orientation == Qt.Horizontal
            enabled:slider.enabled
        }
    }

    handle: null
    valueIndicator: null
}
