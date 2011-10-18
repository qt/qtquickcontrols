import QtQuick 1.1
import "custom" as Components

// jb : Size should not depend on background, we should make it consistent

Components.CheckBox {
    id: checkbox
    property string text
    property string styleHint

    implicitWidth: Math.max(120, backgroundItem.implicitWidth)
    implicitHeight: backgroundItem.implicitHeight

    background: StyleItem {
        elementType: "checkbox"
        sunken: pressed
        on: checked || pressed
        hover: containsMouse
        enabled: checkbox.enabled
        hasFocus: checkbox.activeFocus
        hint: checkbox.styleHint
        contentHeight: textitem.implicitHeight
        contentWidth: textitem.implicitWidth + indicatorWidth
        property int indicatorWidth: pixelMetric("indicatorwidth") + 2
        Text {
            id: textitem
            text: checkbox.text
            anchors.left: parent.left
            anchors.leftMargin: parent.indicatorWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            elide: Text.ElideRight
        }
    }
}

