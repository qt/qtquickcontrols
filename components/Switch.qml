import QtQuick 2.0
import "custom" as Components

Components.Switch {
    id:widget
    minimumWidth:100
    minimumHeight:30

    groove:StyleItem {
        elementType:"edit"
        sunken: true
    }

    handle: StyleItem {
        elementType:"button"
        width:widget.width/2
        height:widget.height-4
        hover:containsMouse
    }
}

