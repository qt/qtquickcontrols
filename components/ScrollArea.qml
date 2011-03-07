import QtQuick 1.0
import "custom" as Components
import "plugin"

FocusScope {
    id:scrollarea
    width: 100
    height: 100

    property int __scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    property int frameWidth: styleitem.pixelMetric("defaultframewidth");
    property int contentHeight : content.childrenRect.height
    property int contentWidth: content.childrenRect.width
    property alias color: flickable.color
    property bool frame: true
    property bool highlightOnFocus: false

    default property alias children: content.children

    property int contentY
    property int contentX

    property bool frameAroundContents: styleitem.styleHint("framearoundcontents")

    onContentYChanged: { vscrollbar.value = contentY }
    onContentXChanged: { hscrollbar.value = contentX }

    property int frameMargins : frame ? frameWidth : 0

    QStyleBackground {
        style: QStyleItem{
            id:styleitem
            elementType: frame ? "frame" : ""
            sunken: true
        }
        anchors.fill: parent
        anchors.rightMargin: frame ? (frameAroundContents ? (vscrollbar.visible ? vscrollbar.width + 2 * frameMargins : 0) : -frameWidth) : 0
        anchors.bottomMargin: frame ? (frameAroundContents ? (hscrollbar.visible ? hscrollbar.height + 2 * frameMargins : 0) : -frameWidth) : 0
        anchors.topMargin: frame ? (frameAroundContents ? 0 : -frameWidth) : 0

        Rectangle {
            id:flickable
            color: "transparent"
            anchors.fill: parent
            anchors.margins: frameMargins
            clip: true

            Item {
                id: docmargins
                anchors.fill:parent
                anchors.margins:frameMargins
                Item {
                    id: content
                    x: -scrollarea.contentX
                    y: -scrollarea.contentY
                }
            }
        }
    }

    ScrollBar {
        id: hscrollbar
        orientation: Qt.Horizontal
        property int availableWidth : scrollarea.width - (frame ? (vscrollbar.width) : 0)
        visible: contentWidth > availableWidth
        maximumValue: contentWidth > availableWidth ? scrollarea.contentWidth - availableWidth: 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: { vscrollbar.visible ? __scrollbarExtent : (frame ? 1 : 0) }
        onValueChanged: contentX = value
    }

    ScrollBar {
        id: vscrollbar
        orientation: Qt.Vertical
        property int availableHeight : scrollarea.height - (frame ? (hscrollbar.height) : 0)
        visible: contentHeight > availableHeight
        maximumValue: contentHeight > availableHeight ? scrollarea.contentHeight - availableHeight : 0
        minimumValue: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: styleitem.style == "mac" ? 1 : 0
        onValueChanged: contentY = value
        anchors.bottomMargin: (frameAroundContents && hscrollbar.visible) ? hscrollbar.height : 0
    }

    QStyleBackground {
        z: 2
        anchors.fill: parent
        anchors.margins: -4
        visible: highlightOnFocus && parent.activeFocus && styleitem.styleHint("focuswidget")
        style: QStyleItem {
            id:framestyle
            elementType: "focusframe"
        }
    }
}
