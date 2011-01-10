import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.TextField {
    id:textfield
    leftMargin:12
    rightMargin:12
    minimumWidth:200
    desktopBehavior:true
    placeholderText:""
    background: QStyleItem {
        elementType:"edit"
        anchors.fill:textfield
        sunken:true
        focus:textfield.activeFocus
        hover:containsMouse
    }
}
