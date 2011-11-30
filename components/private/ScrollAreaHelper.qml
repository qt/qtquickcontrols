import QtQuick 1.1
import "../"

WheelArea {
    id: wheelarea

    property alias horizontalScrollBar: hscrollbar
    property alias verticalScrollBar: vscrollbar
    property int macOffset: frame && styleitem.style === "mac" ? 1 : 0
    property bool blockUpdates: false
    property int availableHeight : root.height - (hscrollbar.visible ? hscrollbar.height : 0)
    property int availableWidth: root.width - vscrollbar.width

    anchors.fill: parent
    anchors.margins: frameWidth
    horizontalMinimumValue: hscrollbar.minimumValue
    horizontalMaximumValue: hscrollbar.maximumValue
    verticalMinimumValue: vscrollbar.minimumValue
    verticalMaximumValue: vscrollbar.maximumValue

    onVerticalValueChanged: {
        if (!blockUpdates)
            verticalScrollBar.value = verticalValue
    }

    onHorizontalValueChanged: {
        if (!blockUpdates)
            horizontalScrollBar.value = horizontalValue
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
        visible: contentWidth > availableWidth
        maximumValue: contentWidth > availableWidth ? root.contentWidth - availableWidth : 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.leftMargin: parent.macOffset
        anchors.bottomMargin: -parent.macOffset
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: vscrollbar.visible ? vscrollbar.width -parent.macOffset: 0
        onValueChanged: {
            if (!blockUpdates) {
                contentX = value
                horizontalValue = value
            }
        }
    }

    ScrollBar {
        id: vscrollbar
        orientation: Qt.Vertical
        // We cannot bind directly to tree.height due to binding loops so we have to redo the calculation here
        visible: contentHeight > availableHeight
        maximumValue: contentHeight > availableHeight ? root.contentHeight - availableHeight : 0
        minimumValue: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: parent.macOffset
        anchors.rightMargin: -parent.macOffset
        anchors.bottomMargin: hscrollbar.visible ? hscrollbar.height - parent.macOffset :  0

        onValueChanged: {
            if (!blockUpdates) {
                contentY = value
                verticalValue = value
            }
        }
    }
}
