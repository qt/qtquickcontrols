import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox{
    id:checkbox
    property variant text

    background: QStyleBackground {
        id:styleitem
        width:110
        height:18
        style:QStyleItem {
            elementType:"checkbox"
            sunken:pressed
            on:checked || pressed
            hover:containsMouse
            text:checkbox.text
            enabled:checkbox.enabled
        }
    }

    checkmark: Item{}
}

