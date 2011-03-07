import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.Button {
    id:button

    width: 100
    height: Math.max(22, sizehint.height)
    property variant sizehint: styleitem.sizeFromContents(80, 6)

    property bool defaultbutton

    QStyleItem {
        id: styleitem
        elementType: "button"
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled: button.enabled
        text: iconSource === "" ? "" : button.text
        focus: button.focus
        // If no icon, let the style do the drawing
        activeControl: focus ? "default" : ""
    }

    background: QStyleBackground {
        style:styleitem
        anchors.fill:parent
        Connections{
            target: button
            onToolTipTriggered: showTip()
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
                text: styledItem.text
                horizontalAlignment: Text.Center
            }
        }
    }
    Keys.onSpacePressed:clicked()
}

