import QtQuick 1.1
import "custom" as Components

Components.Button {
    id: button

    implicitWidth: Math.max(72, backgroundItem.implicitWidth)
    implicitHeight: Math.max(22, backgroundItem.implicitHeight)

    property alias containsMouse: tooltip.containsMouse
    property bool defaultbutton: false
    property string styleHint

    TooltipArea {
        // Note this will eat hover events
        id: tooltip
        anchors.fill: parent
        text: button.tooltip
    }

    background: StyleItem {
        id: styleitem
        anchors.fill: parent
        elementType: "button"
        sunken: pressed || checked
        raised: !(pressed || checked)
        hover: containsMouse
        text: iconSource === "" ? "" : button.text
        hasFocus: button.focus
        hint: button.styleHint

        // If no icon, let the style do the drawing
        activeControl: defaultbutton ? "default" : "f"
    }

    label: Item {
        // Used as a fallback since I can't pass the imageURL
        // directly to the style object
        visible: button.iconSource === ""
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 4
            Image {
                source: iconSource
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.Stretch //mm Image should shrink if button is too small, depends on QTBUG-14957
            }
            Text {
                id:text
                color: textColor
                anchors.verticalCenter: parent.verticalCenter
                text: button.text
                horizontalAlignment: Text.Center
            }
        }
    }
    Keys.onSpacePressed:animateClick()
}

