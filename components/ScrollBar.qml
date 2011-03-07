import QtQuick 1.0
import "custom" as Components
import "plugin"

MouseArea {
    id:scrollbar

    width: orientation == Qt.Horizontal ? 200 : __scrollbarExtent;
    height: orientation == Qt.Horizontal ? __scrollbarExtent : 200

    property int orientation : Qt.Horizontal
    property alias minimumValue: slider.minimumValue
    property alias maximumValue: slider.maximumValue
    property alias value: slider.value

    property bool upPressed;
    property bool downPressed;
    property bool __autoincrement: false
    property int __scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");

    // Update hover item
    onEntered: styleitem.activeControl = bgitem.hitTest(mouseX, mouseY)
    onExited: styleitem.activeControl = "none"
    onMouseXChanged: styleitem.activeControl = bgitem.hitTest(mouseX, mouseY)
    hoverEnabled:true

    Timer { running: upPressed || downPressed; interval: 350 ; onTriggered: __autoincrement = true }
    Timer { running: __autoincrement; interval: 60 ; repeat: true ;
        onTriggered: upPressed ? decrement() : increment() }

    onPressed: {
        var control = bgitem.hitTest(mouseX,mouseY)
        if (control == "up") {
            upPressed = true
        } else if (control == "down") {
            downPressed = true
        }
    }

    onReleased: {
        __autoincrement = false;
        if (upPressed) {
            upPressed = false;
            decrement()
        } else if (downPressed) {
            increment()
            downPressed = false;
        }
    }

    function increment() {
        value += 30
        if (value > maximumValue)
            value = maximumValue
    }

    function decrement() {
        value -= 30
        if (value < minimumValue)
            value = minimumValue
    }

    QStyleBackground {
        id:bgitem
        anchors.fill:parent
        style: QStyleItem {
            id:styleitem
            elementType: "scrollbar"
            hover: activeControl != "none"
            activeControl: "none"
            sunken: upPressed | downPressed
            minimum: slider.minimumValue
            maximum: slider.maximumValue
            value: slider.value
            horizontal: orientation == Qt.Horizontal
            enabled: parent.enabled
        }
    }

    property variant handleRect
    function updateHandle() {
        handleRect = bgitem.subControlRect("handle")
        var grooveRect = bgitem.subControlRect("groove");
        var extra = 0
        if (orientation == Qt.Vertical) {
            slider.anchors.topMargin = grooveRect.y + extra
            slider.anchors.bottomMargin = height - grooveRect.y - grooveRect.height + extra
        } else {
            slider.anchors.leftMargin = grooveRect.x + extra
            slider.anchors.rightMargin = width - grooveRect.x - grooveRect.width + extra
        }
    }

    onValueChanged: updateHandle()
    onMaximumValueChanged: updateHandle()
    onMinimumValueChanged: updateHandle()
    Component.onCompleted: updateHandle()
    Components.Slider {
        id:slider
        anchors.fill:parent
        orientation:scrollbar.orientation
        leftMargin: (orientation === Qt.Horizontal) ? handleRect.width/2 : handleRect.height/2
        rightMargin:leftMargin
        handle: Item {
            width:orientation == Qt.Vertical ? handleRect.height : handleRect.width;
            height:orientation == Qt.Vertical ? handleRect.width : handleRect.height
        }
        groove:null
        valueIndicator:null
        inverted:orientation != Qt.Horizontal
    }
}
