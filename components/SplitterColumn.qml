import QtQuick 1.1
import "custom" as Components

Components.SplitterColumn {
    handleBackground: StyleItem {
            id: styleitem
            elementType: "splitter"
            height: pixelMetric("splitterwidth")
            property alias pressed: mouseArea.pressed
            property bool dragged: mouseArea.drag.active

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.topMargin: (parent.width <= 1) ? -2 : 0
                anchors.bottomMargin: (parent.width <= 1) ? -2 : 0
                drag.axis: Qt.XandYAxis // Why doesn't X-axis work?
                drag.target: handle
                StyleItem {
                    anchors.fill: parent
                    cursor: "splitvcursor"
                }
            }
    }
}
