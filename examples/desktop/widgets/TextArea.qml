import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.TextArea {
    id:textarea
    leftMargin:12
    rightMargin:12
    minimumWidth:200
    desktopBehavior:true
    placeholderText:""

    background: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem{
            elementType:"edit"
            sunken:true
            focus:textarea.activeFocus
        }
    }
}
