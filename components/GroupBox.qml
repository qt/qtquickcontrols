import QtQuick 1.0
import "custom" as Components

Components.GroupBox {
    id: groupbox
    width: adjustToContentSize ? Math.max(200, contentWidth + sizeHint.width) : 200
    height: adjustToContentSize ? contentHeight + sizeHint.height + 4 : 100
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
