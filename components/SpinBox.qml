import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.SpinBox {
    id:spinbox

    property variant __upRect;
    property variant __downRect;
    property int __margin: (height -16)/2

    // Align height with button
    topMargin:__margin
    bottomMargin:__margin

    leftMargin:6
    rightMargin:6

    property int buttonHeight: edititem.sizeFromContents(70, 20).height
    property int buttonWidth: edititem.sizeFromContents(70, 20).width

    QStyleItem { id:edititem; elementType:"edit" }
    height: buttonHeight
    width: buttonWidth
    clip:false

    background:
        Item {
        anchors.fill: parent
        property variant __editRect

        Rectangle {
            id:editBackground
            x: __editRect.x - 1
            y: __editRect.y
            width: __editRect.width
            height: __editRect.height
        }

        Item {
            id:focusFrame
            anchors.fill: editBackground
            visible:framestyle.styleHint("focuswidget")
            QStyleBackground{
                anchors.margins: -6
                anchors.leftMargin: -5
                anchors.rightMargin: -7
                anchors.fill: parent
                visible: spinbox.focus || spinbox.activeFocus
                style: QStyleItem {
                    id:framestyle
                    elementType:"focusframe"
                }
            }
        }

        function updateRect() {
            __upRect = spinboxbg.subControlRect("up");
            __downRect = spinboxbg.subControlRect("down");
            __editRect = spinboxbg.subControlRect("edit");
        }

        Component.onCompleted:updateRect()
        onWidthChanged:updateRect()
        onHeightChanged:updateRect()

        QStyleBackground {
            id:spinboxbg
            anchors.fill:parent
            style: QStyleItem {
                id: styleitem
                elementType: "spinbox"
                sunken: downPressed | upPressed
                hover: containsMouse
                focus: spinbox.focus || spinbox.activeFocus
                enabled: spinbox.enabled
                value: (upPressed? 1 : 0)           |
                        (downPressed== 1 ? 1<<1 : 0) |
                        (upEnabled? (1<<2) : 0)      |
                        (downEnabled == 1 ? (1<<3) : 0)
            }
        }
    }

    up: Item {
        x: __upRect.x
        y: __upRect.y
        width: __upRect.width
        height: __upRect.height
    }

    down: Item {
        x: __downRect.x
        y: __downRect.y
        width: __downRect.width
        height: __downRect.height
    }
}
