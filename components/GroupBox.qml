import QtQuick 2.0
import "custom" as Components
import QtDesktop 0.1

Components.GroupBox {
    id: groupbox
    width: Math.max(200, contentWidth + sizeHint.width)
    height: contentHeight + sizeHint.height + 4
    property variant sizeHint: backgroundItem.sizeFromContents(0, 24)
    property bool flat: false
    background : StyleItem {
        id: styleitem
        elementType: "groupbox"
        anchors.fill: parent
        text: groupbox.title
        hover: checkbox.containsMouse
        on: checkbox.checked
        focus: checkbox.activeFocus
        activeControl: checkable ? "checkbox" : ""
        sunken: !flat
    }
}
