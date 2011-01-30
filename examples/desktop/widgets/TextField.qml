import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

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
    height:20

    QStyleItem {
        id:editItem
        elementType:"edit"
        sunken:true
        focus:textfield.activeFocus
        hover:containsMouse
    }

    // Align with button
    property int buttonHeight: editItem.sizeFromContents(100, 15).height
    //    height: buttonHeight

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
        parent:textfield.parent
        visible:framestyle.styleHint("focuswidget")
        QStyleBackground{
            anchors.margins: -1
            anchors.rightMargin:-5
            anchors.bottomMargin:-5
            anchors.fill: parent
            visible:textfield.activeFocus
            style: QStyleItem {
                id:framestyle
                elementType:"focusframe"
            }
        }
    }
}
