import QtQuick 1.1
import "custom" as Components

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox {
    id: radiobutton
    property string text
    property string hint
    width: 110
    height: 20

    background: StyleItem {
        elementType: "radiobutton"
        sunken: pressed
        on: checked || pressed
        hover: containsMouse
        text: radiobutton.text
        enabled: radiobutton.enabled
        hasFocus: radiobutton.activeFocus
        styleHint: radiobutton.hint
    }
    Keys.onSpacePressed: {clicked(); checked = !checked; }
}

