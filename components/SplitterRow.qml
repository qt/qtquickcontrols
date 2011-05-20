import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.SplitterRow {
    handleBackground: Rectangle {
        color: handleIndex === 0 ? "black" : "blue"
        width: 3

        MouseArea {
            anchors.fill: parent
            anchors.leftMargin: -10
            anchors.rightMargin: -parent.width - 10
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
