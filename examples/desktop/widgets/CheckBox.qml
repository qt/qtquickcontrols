import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox{
    id:checkbox
    property variant text

    background: QStyleItem {
        id:styleitem
        elementType:"checkbox"
        width:120
        height:18
        sunken:pressed
        on:checked || pressed
        hover:containsMouse
        text:checkbox.text
    }

    checkmark: Item{}
}

