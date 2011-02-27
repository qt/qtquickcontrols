import QtQuick 1.0
import "custom" as Components
import "plugin"

Item {
    width:200
    height:40

    property alias text: styleitem.text
    default property alias children: content.children
    property bool checkable: false

    QStyleBackground {
        anchors.fill:parent
        style: QStyleItem{
            id:styleitem
            elementType:"groupbox"
        }

        Item {
            id:content
            anchors.topMargin:22
            anchors.leftMargin:6
            anchors.fill:parent
        }
    }
}
