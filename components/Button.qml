import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.Button {
    id:button

    property int buttonHeight: Math.max(22, styleitem.sizeFromContents(100, 6).height)
    property bool defaultbutton
    height: buttonHeight

    onClicked: button.focus = true

    QStyleItem {
        id: styleitem
        elementType: "button"
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled: button.enabled
        text: button.text
        focus: button.focus
        activeControl: defaultbutton ? "default" : ""
    }

    background:
    QStyleBackground {
        style:styleitem
        anchors.fill:parent
    }
}

