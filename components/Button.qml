import QtQuick 1.0
import "custom" as Components

Components.Button {
    id:button

    width: Math.max(80, sizehint.width)
    height: Math.max(22, sizehint.height)

    property variant sizehint: backgroundItem.sizeFromContents(80, 6)
    property bool defaultbutton
    property string hint

    background: StyleItem {
        id: styleitem
        anchors.fill: parent
        elementType: "button"
        sunken: pressed || checked
        raised: !(pressed || checked)
        hover: containsMouse
        text: iconSource === "" ? "" : button.text
        focus: button.focus
        hint: button.hint

        // If no icon, let the style do the drawing
        activeControl: focus ? "default" : ""
        Connections{
            target: button
            onToolTipTriggered: styleitem.showTip()
        }
        function showTip(){
            showToolTip(tooltip);
        }
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
    Keys.onSpacePressed:clicked()
}

