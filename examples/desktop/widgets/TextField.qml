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

    // Align with button
    property int buttonHeight: buttonitem.sizeFromContents(100, 15).height
    QStyleItem { id:buttonitem; elementType:"button" }
    height: buttonHeight

    background: QStyleBackground{
        style : QStyleItem {
            elementType:"edit"
            sunken:true
            focus:textfield.activeFocus
            hover:containsMouse
        }
    }
}
