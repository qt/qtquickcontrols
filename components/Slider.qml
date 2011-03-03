import QtQuick 1.0
import "custom" as Components
import "plugin"

// jens: ContainsMouse breaks drag functionality

Components.Slider{
    id: slider

    // Align with button
    property int buttonWidth: buttonitem.sizeFromContents(30, 200).width
    property int buttonHeight: buttonitem.sizeFromContents(30, 200).height
    property bool tickmarksEnabled: true

    QStyleItem { id:buttonitem; elementType: "slider" }
    height: orientation == Qt.Vertical ? buttonHeight : buttonWidth
    width: orientation == Qt.Vertical ? buttonWidth : buttonHeight

    groove: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem {
            elementType: "slider"
            sunken: pressed
            maximum: slider.maximumValue
            minimum: slider.minimumValue
            value: slider.value
            horizontal: slider.orientation == Qt.Horizontal
            enabled: slider.enabled
            focus: slider.focus
            activeControl: tickmarksEnabled ? "ticks" : ""
        }
    }

    handle: null
    valueIndicator: null

    Keys.onRightPressed: value += (maximumValue - minimumValue)/10.0
    Keys.onLeftPressed: value -= (maximumValue - minimumValue)/10.0

}
