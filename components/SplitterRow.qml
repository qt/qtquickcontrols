import QtQuick 1.1
import "custom" as Components

Components.Splitter {
    orientation: Qt.Horizontal
    handleBackground: StyleItem {
        id: styleitem
        elementType: "splitter"
        width: handleWidth != -1 ?  handleWidth : pixelMetric("splitterwidth")
        property alias pressed: mouseArea.pressed
        property bool dragged: mouseArea.drag.active

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.leftMargin: (parent.width <= 1) ? -2 : 0
            anchors.rightMargin: (parent.width <= 1) ? -2 : 0
            drag.axis: Qt.YAxis
            drag.target: handle

            CursorArea {
                anchors.fill: parent
                cursor: CursorArea.SplitHCursor
            }
        }
    }
}
