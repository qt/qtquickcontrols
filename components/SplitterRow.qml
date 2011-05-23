import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.SplitterRow {
    handleBackground: QStyleItem {
            id: styleitem
            elementType: "splitter"
            width: pixelMetric("splitterwidth")

            MouseArea {
                anchors.fill: parent
//                anchors.leftMargin: (width <= 1) ? -2 : 0
//                anchors.rightMargin: (width <= 1) ? -2 : 0
                drag.axis: Qt.YAxis
                drag.target: handleDragTarget
                onMouseXChanged: handleDragged(handleIndex)

                QStyleItem {
                    anchors.fill: parent
                    cursor: "splithcursor"
                }
            }
    }
}
