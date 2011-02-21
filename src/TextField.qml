import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.TextField {
    id:textfield
    minimumWidth:200
    desktopBehavior:true
    placeholderText:""
    topMargin:2
    bottomMargin:2
    leftMargin:6
    rightMargin:6
    width:200
    height: editItem.sizeFromContents(100, 20).height
    clip:false

    QStyleItem {
        id:editItem
        elementType:"edit"
        sunken:true
        focus:textfield.activeFocus
        hover:containsMouse
    }

    background: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem{
            elementType:"edit"
            sunken:true
            focus:textfield.activeFocus
        }
    }

    Item{
        id:focusFrame
        anchors.fill: textfield
        parent:textfield
        visible:framestyle.styleHint("focuswidget")
        QStyleBackground{
            anchors.margins: -2
            anchors.rightMargin:-4
            anchors.bottomMargin:-4
            anchors.fill: parent
            visible:textfield.activeFocus
            style: QStyleItem {
                id:framestyle
                elementType:"focusframe"
            }
        }
    }
}
