import QtQuick 1.1
import "custom" as Components

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox {
    id:checkbox
    property string text
    property string styleHint
    property bool activeFocusOnPress: false
    implicitWidth: Math.max(110, backgroundItem.textWidth(text) + 40)
    implicitHeight: 20

    background: StyleItem {
        id: styleitem
        elementType: "checkbox"
        sunken: pressed
        on: checked || pressed
        hover: containsMouse
        text: checkbox.text
        enabled: checkbox.enabled
        hasFocus: checkbox.activeFocus
        hint: checkbox.styleHint
    }
}

