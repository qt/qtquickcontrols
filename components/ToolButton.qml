import QtQuick 1.1
import "custom" as Components

Components.Button {
    id:button

    property alias containsMouse: tooltip.containsMouse
    property string iconName
    property string styleHint

    implicitWidth: styleitem.sizeFromContents(32, 32).width
    implicitHeight: styleitem.sizeFromContents(32, 32).height

    onIconNameChanged: {
        if (styleitem.hasThemeIcon(iconName)) {
            themeIcon.source = "image://desktoptheme/" + button.iconName;
        }
    }

    StyleItem {elementType: "toolbutton"; id:styleitem}

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
        Text {
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
        sourceSize.width: (styleitem.style === "mac" && button.styleHint.indexOf("mac.segmented") !== -1) ? 16 : 32
        fillMode: Image.PreserveAspectFit
        Image {
            // Use fallback icon
            anchors.centerIn: parent
            visible: (themeIcon.status != Image.Ready)
            source: visible ? button.iconSource : ""
        }
    }
}
