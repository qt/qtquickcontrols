import QtQuick 1.0
import "custom" as Components
import "plugin"

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox {
    id:radiobutton
    property string text
    width:110
    height:20
    background: QStyleBackground {

        style: QStyleItem{
            elementType:"radiobutton"
            sunken:pressed
            on:checked || pressed
            hover:containsMouse
            text:radiobutton.text
            enabled:radiobutton.enabled
            focus:radiobutton.focus
        }
    }
    Keys.onSpacePressed:clicked()
}

