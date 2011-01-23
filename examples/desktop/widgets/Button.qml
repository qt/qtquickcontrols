import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    id:button

    property int buttonHeight: styleitem.sizeFromContents(100, 15).height
    height: buttonHeight

    QStyleItem {
        id:styleitem
        elementType:"button"
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled:button.enabled
    }

    background: QStyleBackground {
        style:styleitem
        anchors.fill:parent
    }
}

