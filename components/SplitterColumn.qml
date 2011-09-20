import QtQuick 1.1
import "custom" as Components

Components.SplitterColumn {
    handleBackground: StyleItem {
            id: styleitem
            elementType: "splitter"
            height: pixelMetric("splitterwidth")
            horizontal: false
            property alias pressed: mouseArea.pressed
            property bool dragged: mouseArea.drag.active

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.topMargin: (parent.height <= 1) ? -2 : 0
                anchors.bottomMargin: (parent.height <= 1) ? -2 : 0
                drag.axis: Qt.XandYAxis // Why doesn't X-axis work?
                drag.target: handle
                CursorArea {
                    anchors.fill: parent
                    cursor: CursorArea.SplitVCursor
                }
            }
    }
}
