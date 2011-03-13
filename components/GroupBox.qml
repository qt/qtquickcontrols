import QtQuick 1.0
import "custom" as Components
import "plugin"

Item {

    width: Math.max(200, content.childrenRect.width)
    height: 40

    default property alias children: content.children
    property alias text: styleitem.text
    property bool checkable: false

    QStyleItem {
        id:styleitem
        elementType:"groupbox"
        anchors.fill:parent

        Item {
            id:content
            anchors.topMargin:24
            anchors.leftMargin:6
            anchors.top:parent.top
            anchors.left:parent.left
        }
    }
}
