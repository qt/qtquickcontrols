import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

// jb : Size should not depend on background, we should make it consistent

Components.RadioButton{

    background: QStyleItem {
        elementType:"radiobutton"
        width:16
        height:16
        sunken:pressed
        on:checked || pressed
        hover:containsMouse
    }
    checkmark: Item{}
}

