import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item {
    id:scrollarea
    width:100
    height:100

    property int __scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    property int contentHeight : content.childrenRect.height
    property int contentWidth: content.childrenRect.width
    property alias color: flickable.color
    property bool frame: true

    default property alias children: content.children

    property int contentY:scrollbar.value
    property int contentX:0

    QStyleItem {
        id:styleitem
        elementType: "frame"
        sunken: true
        anchors.fill: parent
        anchors.rightMargin: scrollbar.width + 4

        Rectangle {
            id:flickable
            color: "transparent"
            anchors.fill: parent
            anchors.margins: frame ? 2 : 0
            clip: true

            Item {
                id: content
                x: scrollarea.contentX
                y: -scrollarea.contentY
            }
        }
    }
/*
    ScrollBar {
        id: hscrollbar
        orientation: Qt.Horizontal
        maximum: contentWidth > flickable.width ? scrollarea.contentWidth -
                flickable.width : 0
        minimum: 0
        value: scrollarea.contentY
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: frame ? 1 + __scrollbar : __scrollbarExtent
    }
    */
    ScrollBar {
        id: scrollbar
        orientation: Qt.Vertical
        maximum: contentHeight > flickable.height ? scrollarea.contentHeight-
                flickable.height : 0
        minimum: 0
        value: scrollarea.contentY
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: frame ? 1 :0; //+ __scrollbar : __scrollbarExtent
    }
}
