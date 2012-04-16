import QtQuick 1.1
import "custom" as Components
import "private" as Private

FocusScope {
    id: root
    width: 100
    height: 100

    // Cosmetic propeties
    property bool frame: true
    property bool frameAroundContents: styleitem.styleHint("framearoundcontents")
    property bool highlightOnFocus: false
    property alias color: colorRect.color // background color
    property int frameWidth: frame ? styleitem.frameWidth : 0

    // Item properties
    property alias horizontalScrollBar: scroller.horizontalScrollBar
    property alias verticalScrollBar: scroller.verticalScrollBar

    // Viewport properties
    property int contentX
    property int contentY
    property int contentHeight : content.childrenRect.height
    property int contentWidth: content.childrenRect.width
    property int viewportHeight: height - (horizontalScrollBar.visible ? horizontalScrollBar.height : 0) - 2 * frameWidth
    property int viewportWidth: width - (verticalScrollBar.visible ? verticalScrollBar.width : 0) - 2 * frameWidth
    default property alias data: content.data

    Rectangle {
        id: colorRect
        color: "transparent"
        anchors.fill:styleitem
        anchors.margins: frameWidth
    }

    StyleItem {
        id: styleitem
        elementType: "frame"
        sunken: true
        visible: frame
        anchors.fill: parent
        anchors.rightMargin: frame ? (frameAroundContents ? (verticalScrollBar.visible ? verticalScrollBar.width + 2 * frameMargins : 0) : 0) : 0
        anchors.bottomMargin: frame ? (frameAroundContents ? (horizontalScrollBar.visible ? horizontalScrollBar.height + 2 * frameMargins : 0) : 0) : 0
        anchors.topMargin: frame ? (frameAroundContents ? 0 : 0) : 0
        property int frameWidth
        property int scrollbarspacing: styleitem.pixelMetric("scrollbarspacing");
        property int frameMargins : frame ? scrollbarspacing : 0
        Component.onCompleted: frameWidth = styleitem.pixelMetric("defaultframewidth");
    }

    onContentYChanged: {
        scroller.blockUpdates = true
        verticalScrollBar.value = contentY
        scroller.verticalValue = contentY
        scroller.blockUpdates = false
    }

    onContentXChanged: {
        scroller.blockUpdates = true
        horizontalScrollBar.value = contentX
        scroller.horizontalValue = contentX
        scroller.blockUpdates = false
    }

    Item {
        id: clipper
        anchors.fill: styleitem
        anchors.margins: frameWidth
        clip: true
        Item {
            id: content
            x: -root.contentX
            y: -root.contentY
        }
    }


    Private.ScrollAreaHelper {
        id: scroller
        anchors.fill: parent
    }

    StyleItem {
        z: 2
        anchors.fill: parent

        anchors.topMargin: -3
        anchors.leftMargin: -3
        anchors.rightMargin: -5
        anchors.bottomMargin: -5

        visible: highlightOnFocus && parent.activeFocus && styleitem.styleHint("focuswidget")
        elementType: "focusframe"
    }
}
