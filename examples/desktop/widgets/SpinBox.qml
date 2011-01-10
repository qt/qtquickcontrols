import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.SpinBox {
    id:spinbox
    property variant __upRect;
    property variant __downRect;
    background: QStyleItem {
        id:styleitem
        elementType:"spinbox"
        anchors.fill:parent
        sunken: true
        hover: containsMouse
        focus:spinbox.activeFocus
        enabled:spinbox.enabled
        value: (upPressed? 1 : 0)           |
               (downPressed== 1 ? 1<<1 : 0) |
               (upEnabled? (1<<2) : 0)      |
               (downEnabled == 1 ? (1<<3) : 0)

        function updateRect() {
            __upRect = styleitem.subControlRect("up");
            __downRect = styleitem.subControlRect("down");
        }
        Component.onCompleted:updateRect()
        onWidthChanged:updateRect()
        onHeightChanged:updateRect()
    }

    up:Item {
        width:__upRect.width > 0 ? __upRect.width : 20
        height:spinbox.height/2
        onWidthChanged: print(__upRect.width)
        onXChanged: print("x" +x)
    }

    down:Item{
        width:__downRect.width > 0 ? __downRect.width : 20
        height:spinbox.height/2
    }
}

