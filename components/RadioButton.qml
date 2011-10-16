import QtQuick 1.1
import "custom" as Components

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox {
    id: radiobutton
    property string text
    property string styleHint

    implicitWidth: Math.max(110, backgroundItem.textWidth(text) + 40)
    implicitHeight: 20

    background: StyleItem {
        elementType: "radiobutton"
        sunken: pressed
        on: checked || pressed
        hover: containsMouse
        text: radiobutton.text
        enabled: radiobutton.enabled
        hasFocus: radiobutton.activeFocus
        hint: radiobutton.styleHint
    }
    Keys.onSpacePressed: {clicked(); checked = !checked; }
}

