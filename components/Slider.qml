import QtQuick 1.1
import "custom" as Components

// jens: ContainsMouse breaks drag functionality

Components.Slider{
    id: slider

    property bool tickmarksEnabled: false
    property string tickPosition: "Below" // "Above", "Below", "BothSides"

    StyleItem {
        id:buttonitem
        elementType: "slider"
        contentWidth:23
        contentHeight:23
    }

    property int orientation: Qt.Horizontal

    implicitWidth: orientation === Qt.Horizontal ? 200 : buttonitem.implicitHeight
    implicitHeight: orientation === Qt.Horizontal ? buttonitem.implicitHeight : 200

    property string styleHint;

    groove: StyleItem {
        anchors.fill:parent
        elementType: "slider"
        sunken: pressed
        maximum: slider.maximumValue*100
        minimum: slider.minimumValue*100
        step: slider.stepSize*100
        value: slider.value*100
        horizontal: slider.orientation == Qt.Horizontal
        enabled: slider.enabled
        hasFocus: slider.focus
        hint: slider.styleHint
        activeControl: tickmarksEnabled ? tickPosition.toLowerCase() : ""
    }

    handle: null
    valueIndicator: null

    Keys.onRightPressed: value += (maximumValue - minimumValue)/10.0
    Keys.onLeftPressed: value -= (maximumValue - minimumValue)/10.0

    WheelArea {
        id: wheelarea
        anchors.fill: parent
        horizontalMinimumValue: slider.minimumValue
        horizontalMaximumValue: slider.maximumValue
        verticalMinimumValue: slider.minimumValue
        verticalMaximumValue: slider.maximumValue
        property double step: (slider.maximumValue - slider.minimumValue)/100

        onVerticalWheelMoved: {
            value += verticalDelta/4*step
        }

        onHorizontalWheelMoved: {
            value += horizontalDelta/4*step
        }
    }

}
