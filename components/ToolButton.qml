import QtQuick 1.0
import "custom" as Components

Components.Button {
    id:button

    height: 40; //styleitem.sizeFromContents(32, 32).height
    width: 40; //styleitem.sizeFromContents(32, 32).width

    property string iconName

    onIconNameChanged: {
        if (styleitem.hasThemeIcon(iconName)) {
            themeIcon.source = "image://desktoptheme/" + button.iconName;
        }
    }

    StyleItem {elementType: "toolbutton"; id:styleitem}

    background: StyleItem {
        id: styleitem
        anchors.fill: parent
        elementType: "toolbutton"
        on: pressed | checked
        sunken: pressed
        raised: containsMouse
        hover: containsMouse

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
        Image {
            // Use fallback icon
            anchors.centerIn: parent
            visible: (themeIcon.status != Image.Ready)
            source: visible ? button.iconSource : ""
        }
    }
}
