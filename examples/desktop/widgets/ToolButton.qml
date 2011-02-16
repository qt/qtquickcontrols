import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    id:button
    minimumWidth:30
    background: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem{
            elementType:"toolbutton"
            on: pressed | checked
            sunken: pressed
            raised: containsMouse
            hover: containsMouse
        }
    }
}

