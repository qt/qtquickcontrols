import QtQuick 1.0
import "custom" as Components
Item {
    default property alias children: content.children
    width: Math.max(100, content.childrenRect.width + 2 * content.frameWidth)
    height: Math.max(100, content.childrenRect.height + 2 * content.frameWidth)
    property alias raised: style.raised
    property alias sunken: style.sunken
    QStyleItem {
        id: style
        anchors.fill: parent
        elementType: "frame"
        Item {
            id: content
            anchors.fill: parent
            anchors.margins: frameWidth
            property int frameWidth: styleitem.pixelMetric("defaultframewidth");
        }
    }
}

