import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.Button {
    id:button

    width: 40
    height: 40

    QStyleItem {elementType: "toolbutton"; id:styleitem  }

    background: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem {
            id:styleitem
            elementType: "toolbutton"
            on: pressed | checked
            sunken: pressed
            raised: containsMouse
            hover: containsMouse

        }
        Image{
            source:button.iconSource
            anchors.centerIn:parent
        }
    }
}
