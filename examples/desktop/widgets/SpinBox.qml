import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.SpinBox {
    id:spinbox
    background: QStyleItem {
        elementType:"spinbox"
        anchors.fill:parent
        sunken: true
        hover: containsMouse
        focus:spinbox.activeFocus
        value: (upPressed? 1 : 0) | (downPressed== 1 ? 1<<1 : 0) |
               (upEnabled? (1<<2) : 0) | (downEnabled == 1 ? (1<<3) : 0)
    }
    up:Item{width:20;height:spinbox.height/2;}
    down:Item{width:20;height:spinbox.height/2}
}

