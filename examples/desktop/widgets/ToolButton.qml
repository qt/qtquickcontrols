import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    id:button
    minimumWidth:30
    background: QStyleBackground {
        anchors.fill:parent
        visible: pressed
        style: QStyleItem{
            elementType:"button"
            sunken: pressed
            hover: containsMouse
        }
    }
}

