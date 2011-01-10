import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item {
    width:200
    height:60

    default property alias children: content.children

    QStyleItem {
        id:styleitem
        elementType:"toolbar"
        anchors.fill:parent
        Row {
            id:content
            anchors.margins:2
            anchors.fill:parent
        }
    }
}
