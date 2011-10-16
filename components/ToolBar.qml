import QtQuick 1.1
import "."
import "custom" as Components

StyleItem {
    id: toolbar
    width: parent ? parent.width : 200
    height: implicitHeight
    elementType: "toolbar"
}
