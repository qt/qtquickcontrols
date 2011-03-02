import QtQuick 1.0
import "custom" as Components
import "plugin"

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox{
    id:checkbox
    property string text
    width:100
    height:20

    background: QStyleBackground {
        id:styleitem
        style:QStyleItem {
            elementType:"checkbox"
            sunken:pressed
            on:checked || pressed
            hover:containsMouse
            text:checkbox.text
            enabled:checkbox.enabled
            focus:checkbox.focus
        }
    }
    Keys.onSpacePressed:checked = !checked
}

