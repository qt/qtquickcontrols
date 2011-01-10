import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item {
    id:scrollbar
    property int __scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    width:orientation == Qt.Horizontal ? 200 : __scrollbarExtent;
    height:orientation == Qt.Horizontal ? __scrollbarExtent : 200

    property int orientation : Qt.Horizontal
    property alias minimum: slider.minimumValue
    property alias maximum: slider.maximumValue
    property alias value: slider.value

    QStyleItem {
        id:styleitem
        elementType:"scrollbar"
        anchors.fill:parent
        sunken: true
        minimum:slider.minimumValue
        maximum:slider.maximumValue
        value:slider.value
        horizontal:orientation == Qt.Horizontal
        enabled: parent.enabled
    }

    Components.Slider {
        id:slider
        orientation:scrollbar.orientation
        leftMargin:16
        rightMargin:16
        anchors.fill:parent
        handle:Item{width:(maximum-minimum)/50.0; height:20}
        groove:Item{}
        valueIndicator:Item{}
        inverted:orientation != Qt.Horizontal
    }
}

