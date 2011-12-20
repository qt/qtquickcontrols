import QtQuick 2.0
import "."
import "custom" as Components

Item {
    width: parent ? parent.width : 200
    height: 24
    StyleItem {
        anchors.fill: parent
        elementType: "statusbar"
    }
}
