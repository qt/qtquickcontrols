import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox{

    background: QStyleItem {
        elementType:"checkbox"
        width:16
        height:16
        sunken:pressed
        on:checked || pressed
        hover:containsMouse
    }

    checkmark: Item{}
}

