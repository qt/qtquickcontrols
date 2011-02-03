import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    id:button

    property int buttonHeight: Math.max(22, styleitem.sizeFromContents(100, 6).height)
    height: buttonHeight

    QStyleItem {
        id:styleitem
        elementType:"button"
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled:button.enabled
        text:button.text
    }

    background:
        QStyleBackground {
        style:styleitem
        anchors.fill:parent
    }
}

