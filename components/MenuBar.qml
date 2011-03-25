import QtQuick 1.0
import "custom" as Components
import "plugin"

Item {
    id: menubar
    property list<Menu> menusList
    default property alias menus : menubar.menusList
    property Row row

    Row {
        id: menurow
        anchors.fill: parent
        spacing : 5

        Repeater {
            model : menus.length
            Text {
                text : menus[index].text
            }
        }
    }
}
