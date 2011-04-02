import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.GroupBox {
    id: groupbox
    property variant sizehint: styleitem.sizeFromContents(0, 0)

    background : QStyleItem {
        id: styleitem
        elementType: "groupbox"
        anchors.fill: parent
        text: groupbox.title
        hover: checkbox.containsMouse
        on:  checkbox.checked
        focus: checkbox.activeFocus
        activeControl: checkable ? "checkbox" : ""
    }
}
