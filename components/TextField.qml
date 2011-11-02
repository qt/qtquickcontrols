import QtQuick 2.0
import "custom" as Components
import QtDesktop 0.1

Components.TextField {
    id: textfield
    minimumWidth: 200

    placeholderText: ""
    topMargin: 2
    bottomMargin: 2
    leftMargin: 6
    rightMargin: 6

    implicitWidth: backgroundItem.implicitWidth
    implicitHeight: backgroundItem.implicitHeight

    clip: false

    property string styleHint

    background: StyleItem {
        anchors.fill: parent
        elementType: "edit"
        sunken: true
        hasFocus: textfield.activeFocus
        hover: containsMouse
        hint: textfield.styleHint
        contentWidth: 200
        contentHeight: 25
    }

    Item{
        id: focusFrame
        anchors.fill: textfield
        parent: textfield
        visible: framestyle.styleHint("focuswidget")
        StyleItem {
            id: framestyle
            anchors.margins: -2
            anchors.rightMargin:-4
            anchors.bottomMargin:-4
            anchors.fill: parent
            visible: textfield.activeFocus
            hint: textfield.styleHint
            elementType: "focusframe"
        }
    }
}
