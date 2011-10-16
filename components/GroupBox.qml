import QtQuick 1.1
import "custom" as Components

Components.GroupBox {
    id: groupbox
    implicitWidth: Math.max(200, contentWidth + sizeHint.width)
    implicitHeight: contentHeight + sizeHint.height + 4
    property variant sizeHint:
        backgroundItem.sizeFromContents(0, (title.length > 0 || checkable) ? 24 : 4)
    property bool flat: focus
    background : StyleItem {
        id: styleitem
        elementType: "groupbox"
        anchors.fill: parent
        text: groupbox.title
        hover: checkbox.containsMouse
        on: checkbox.checked
        hasFocus: checkbox.activeFocus
        activeControl: checkable ? "checkbox" : ""
        sunken: !flat
    }
}
