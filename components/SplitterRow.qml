import QtQuick 1.1
import "custom" as Components
import "plugin"

Components.SplitterRow {
    handleBackground: QStyleItem {
            id: styleitem
            elementType: "splitter"
            width: pixelMetric("splitterwidth")
            property alias pressed: mouseArea.pressed
            property bool dragged: mouseArea.drag.active

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.leftMargin: (parent.width <= 1) ? -2 : 0
                anchors.rightMargin: (parent.width <= 1) ? -2 : 0
                drag.axis: Qt.YAxis
                drag.target: handle

                QStyleItem {
                    anchors.fill: parent
                    cursor: "splithcursor"
                }
            }
    }
}
