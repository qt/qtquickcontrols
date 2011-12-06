import QtQuick 2.0
import "."
import "custom" as Components
import QtDesktop 0.2

StyleItem {
    id: toolbar
    width: parent ? parent.width : 200
    height: implicitHeight
    elementType: "toolbar"
}
