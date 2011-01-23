import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    id:button

    function updateSize() { sizeRect = styleitem.sizeFromContents(labelWidth, labelHeight); print(sizeRect.height) }
    property variant sizeRect
    Component.onCompleted: updateSize()
    onTextChanged: updateSize()
    onIconSourceChanged: updateSize()

    height: sizeRect ? sizeRect.height : 0

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

