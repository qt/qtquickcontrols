import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item {
    width:100
    height:100

    property bool frame: true
    property alias contentHeight: flickable.contentHeight
    property alias contentWidth:  flickable.contentWidth
    default property alias children: content.children

    QStyleItem {
        elementType: "frame"
        sunken: true
        anchors.fill: parent
        anchors.rightMargin: scrollbar.width + 4

        Flickable {
            id:flickable
            anchors.fill: parent
            anchors.margins: frame ? 2 : 0
            contentY: scrollbar.value
            clip: true
            Item{
                id: content
                anchors.fill:parent
            }
        }
    }

    ScrollBar{
        id: scrollbar
        orientation: Qt.Vertical
        maximum: flickable.contentHeight-
                 flickable.height
        minimum: 0
        value: flickable.contentY
        anchors.rightMargin: frame ? 1 : 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
}
