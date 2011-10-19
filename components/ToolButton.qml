import QtQuick 1.1
import "custom" as Components

Components.Button {
    id:button

    property alias containsMouse: tooltip.containsMouse
    property string iconName
    property string styleHint

    implicitWidth: backgroundItem.implicitWidth
    implicitHeight: backgroundItem.implicitHeight

    TooltipArea {
        // Note this will eat hover events
        id: tooltip
        anchors.fill: parent
        text: button.tooltip
    }

    background: StyleItem {
        id: styleitem
        anchors.fill: parent
        elementType: "toolbutton"
        on: pressed | checked
        sunken: pressed
        raised: containsMouse
        hover: containsMouse
        info: __position
        hint: button.styleHint
        contentWidth: Math.max(textitem.paintedWidth, 32)
        contentHeight: 32
        Text {
            id: textitem
            text: button.text
            anchors.centerIn: parent
            visible: button.iconSource == ""
        }
    }
    Image {
        id: themeIcon
        anchors.centerIn: parent
        opacity: enabled ? 1 : 0.5
        smooth: true
        sourceSize.width: (backgroundItem && backgroundItem.style === "mac" && button.styleHint.indexOf("mac.segmented") !== -1) ? 16 : 24
        property string iconPath: "image://desktoptheme/" + button.iconName
        source: backgroundItem && backgroundItem.hasThemeIcon(iconName) ? iconPath : ""
        fillMode: Image.PreserveAspectFit
        Image {
            // Use fallback icon
            anchors.centerIn: parent
            sourceSize: parent.sourceSize
            visible: (themeIcon.status != Image.Ready)
            source: visible ? button.iconSource : ""
        }
    }
}
