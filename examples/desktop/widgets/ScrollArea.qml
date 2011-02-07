import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item {
    id:scrollarea
    width: 100
    height: 100

    property int contentMargin: 1
    property int __scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    property int contentHeight : content.childrenRect.height
    property int contentWidth: content.childrenRect.width
    property alias color: flickable.color
    property bool frame: true

    default property alias children: content.children

    property int contentY
    property int contentX

    onContentYChanged: {
        vscrollbar.value = contentY
    }

    onContentXChanged: {
        hscrollbar.value = contentY
    }

    QStyleBackground {
        style: QStyleItem{
            id:styleitem
            elementType: frame ? "frame" : ""
            sunken: true
        }
        anchors.fill: parent
        anchors.rightMargin: vscrollbar.visible ? vscrollbar.width + 4 : 0
        anchors.bottomMargin: hscrollbar.visible ? hscrollbar.height + 4 : 0

        Rectangle {
            id:flickable
            color: "transparent"
            anchors.fill: parent
            anchors.margins: frame ? 2 : 0
            clip: true

            Item {
                id: docmargins
                anchors.fill:parent
                anchors.margins:contentMargin
                Item {
                    id: content
                    x: scrollarea.contentX
                    y: -scrollarea.contentY
                }
            }
        }
    }

    ScrollBar {
        id: hscrollbar
        orientation: Qt.Horizontal
        visible: contentWidth > flickable.width
        maximumValue: contentWidth > flickable.width ? scrollarea.contentWidth - flickable.width : 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: { return (frame ? 1 : 0) + ( vscrollbar.visible ? __scrollbarExtent : 0) }
        onValueChanged: contentX = value
    }

    ScrollBar {
        id: vscrollbar
        orientation: Qt.Vertical
        visible: contentHeight > flickable.height
        maximumValue: contentHeight > flickable.height ? scrollarea.contentHeight - flickable.height : 0
        minimumValue: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin:  { return (frame ? 1 : 0) + (hscrollbar.visible ? __scrollbarExtent : 0) }
        onValueChanged: contentY = value
    }
}
