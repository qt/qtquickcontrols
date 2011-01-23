import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.SpinBox {
    id:spinbox
    property variant __upRect;
    property variant __downRect;
    property int __margin: (height -15)/2

    // Align height with button
    topMargin:__margin
    bottomMargin:__margin
    property int buttonHeight: buttonitem.sizeFromContents(100, 15).height
    QStyleItem { id:buttonitem; elementType:"button" }
    height: buttonHeight

    QStyleItem {
        id:styleitem
        elementType:"spinbox"
        sunken: downPressed | upPressed
        hover: containsMouse
        focus:spinbox.activeFocus
        enabled:spinbox.enabled
        value: (upPressed? 1 : 0)           |
                (downPressed== 1 ? 1<<1 : 0) |
                (upEnabled? (1<<2) : 0)      |
                (downEnabled == 1 ? (1<<3) : 0)

    }

    background:
        Item {anchors.fill: parent
        property variant editrect
        Rectangle {
            x:editrect.x
            y:editrect.y
            width:editrect.width
            height:editrect.height

        }

        function updateRect() {
            __upRect = spinboxbg.subControlRect("up");
            __downRect = spinboxbg.subControlRect("down");
            editrect = spinboxbg.subControlRect("edit");
        }

        Component.onCompleted:updateRect()
        onWidthChanged:updateRect()
        onHeightChanged:updateRect()

        QStyleBackground {
            id:spinboxbg
            anchors.fill:parent
            style:styleitem
        }
    }


    up:Item {
        width:__upRect.width > 0 ? __upRect.width : 20
        height:spinbox.height/2
    }

    down:Item{
        width:__downRect.width > 0 ? __downRect.width : 20
        height:spinbox.height/2
    }
}

