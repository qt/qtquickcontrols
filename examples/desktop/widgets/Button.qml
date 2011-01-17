import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    id:button

    height: 26

    background: QStyleItem {
        id: styleitem
        elementType:"button"
        anchors.fill:parent
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled:button.enabled
    }
}

