import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

// jens: ContainsMouse breaks drag functionality

Components.Slider{
    id:slider
    minimumWidth:200
    minimumHeight:24

    groove: QStyleItem {
        elementType:"slider"
        anchors.fill:parent
        sunken: pressed
        maximum:slider.maximumValue
        minimum:slider.minimumValue
        value:slider.value
        horizontal:slider.orientation == Qt.Horizontal
        enabled:slider.enabled
    }

    handle: null
    valueIndicator: null
}
