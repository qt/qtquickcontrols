import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    minimumWidth:30
    background: QStyleItem {
        elementType:"button"
        anchors.fill:parent
        sunken: pressed
        visible: sunken
        hover: containsMouse
    }
}

