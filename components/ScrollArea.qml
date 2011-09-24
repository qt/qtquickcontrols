import QtQuick 1.0
import "custom" as Components

FocusScope {
    id: scrollarea
    width: 100
    height: 100

    // Framewidth seems to be 1 regardless of style
    property int frameWidth: frame ? styleitem.frameWidth : 0;
    property int contentHeight : content.childrenRect.height
    property int contentWidth: content.childrenRect.width
    property alias color: colorRect.color
    property bool frame: true
    property bool highlightOnFocus: false
    property bool frameAroundContents: styleitem.styleHint("framearoundcontents")
    property alias verticalValue: vscrollbar.value
    property alias horizontalValue: hscrollbar.value

    property alias horizontalScrollBar: hscrollbar
    property alias verticalScrollBar: vscrollbar

    property int viewportHeight: height - (hscrollbar.visible ? hscrollbar.height : 0) - 2 * frameWidth
    property int viewportWidth: width - (vscrollbar.visible ? vscrollbar.width : 0) - 2 * frameWidth
    property bool blockUpdates: false

    default property alias data: content.data

    property int contentY
    property int contentX


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
        anchors.rightMargin: frame ? (frameAroundContents ? (vscrollbar.visible ? vscrollbar.width + 2 * frameMargins : 0) : 0) : 0
        anchors.bottomMargin: frame ? (frameAroundContents ? (hscrollbar.visible ? hscrollbar.height + 2 * frameMargins : 0) : 0) : 0
        anchors.topMargin: frame ? (frameAroundContents ? 0 : 0) : 0
        property int frameWidth
        property int scrollbarspacing: styleitem.pixelMetric("scrollbarspacing");
        property int frameMargins : frame ? scrollbarspacing : 0
        Component.onCompleted: frameWidth = styleitem.pixelMetric("defaultframewidth");
    }

    onContentYChanged: {
        blockUpdates = true
        vscrollbar.value = contentY
        wheelarea.verticalValue = contentY
        blockUpdates = false
    }
    onContentXChanged: {
        blockUpdates = true
        hscrollbar.value = contentX
        wheelarea.horizontalValue = contentX
        blockUpdates = false
    }

    Item {
        id: flickable
        anchors.fill: styleitem
        anchors.margins: frameWidth
        clip: true

        Item {
            id: content
            x: -scrollarea.contentX
            y: -scrollarea.contentY
        }
    }

    WheelArea {
        id: wheelarea

        property int macOffset: styleitem.style == "mac" ? 1 : 0

        anchors.fill: parent
        anchors.margins: frameWidth
        horizontalMinimumValue: hscrollbar.minimumValue
        horizontalMaximumValue: hscrollbar.maximumValue
        verticalMinimumValue: vscrollbar.minimumValue
        verticalMaximumValue: vscrollbar.maximumValue

        onVerticalValueChanged: {
            if (!blockUpdates)
                contentY = verticalValue
        }

        onHorizontalValueChanged: {
            if (!blockUpdates)
                contentX = horizontalValue
        }

        StyleItem {
            // This is the filled corner between scrollbars
            id: cornerFill
            elementType: "scrollareacorner"
            width: vscrollbar.width
            anchors.right: parent.right
            height: hscrollbar.height
            anchors.bottom: parent.bottom
            visible: hscrollbar.visible && vscrollbar.visible
        }

        ScrollBar {
            id: hscrollbar
            orientation: Qt.Horizontal
            property int availableWidth: scrollarea.width - vscrollbar.width
            visible: contentWidth > availableWidth
            maximumValue: contentWidth > availableWidth ? scrollarea.contentWidth - availableWidth : 0
            minimumValue: 0
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.macOffset
            anchors.bottomMargin: -parent.macOffset
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: vscrollbar.visible ? vscrollbar.width -parent.macOffset: 0
            onValueChanged: {
                if (!tree.blockUpdates)
                    contentX = value
            }
        }

        ScrollBar {
            id: vscrollbar
            orientation: Qt.Vertical
            // We cannot bind directly to tree.height due to binding loops so we have to redo the calculation here
            property int availableHeight : scrollarea.height - (hscrollbar.visible ? hscrollbar.height : 0)
            visible: contentHeight > availableHeight
            maximumValue: contentHeight > availableHeight ? scrollarea.contentHeight - availableHeight : 0
            minimumValue: 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: parent.macOffset
            anchors.rightMargin: -parent.macOffset
            anchors.bottomMargin: hscrollbar.visible ? hscrollbar.height - parent.macOffset :  0

            onValueChanged: {
                if (!blockUpdates)
                    contentY = value
            }
        }
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
