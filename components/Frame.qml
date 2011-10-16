import QtQuick 1.1
import "custom" as Components
Item {
    default property alias data: content.data
    implicitWidth: adjustToContentSize ? content.childrenRect.width + 2 * content.frameWidth : 30
    implicitHeight: adjustToContentSize ? content.childrenRect.height + 2 * content.frameWidth : 30
    property alias raised: style.raised
    property alias sunken: style.sunken
    property bool adjustToContentSize: false
    StyleItem {
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

