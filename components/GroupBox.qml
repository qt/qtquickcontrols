import QtQuick 1.0
import "custom" as Components
import "plugin"

Item {
    width:200
    height:40

    property alias text: styleitem.text
    default property alias children: content.children
    property bool checkable: false

    QStyleItem {
        id:styleitem
        elementType:"groupbox"
        anchors.fill:parent

        Item {
            id:content
            anchors.topMargin:22
            anchors.leftMargin:6
            anchors.fill:parent
        }
    }
}
