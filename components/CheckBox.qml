import QtQuick 1.1
import "custom" as Components

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox {
    id:checkbox
    property string text
    property string hint
    property bool activeFocusOnPress: false
    width: Math.max(110, backgroundItem.textWidth(text) + 40)
    height: 20

    background: StyleItem {
        id: styleitem
        elementType: "checkbox"
        sunken: pressed
        on: checked || pressed
        hover: containsMouse
        text: checkbox.text
        enabled: checkbox.enabled
        hasFocus: checkbox.activeFocus
        styleHint: checkbox.hint
    }
}

