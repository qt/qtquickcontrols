import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.TextField {
    leftMargin:12
    rightMargin:12
    minimumWidth:200
    desktopBehavior:true

    background: QStyleItem {
        elementType:"edit"
        anchors.fill:parent
        focus:parent.focus
        hover:containsMouse
    }
}
