import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

MouseArea {
    id:scrollbar
    property int __scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    width:orientation == Qt.Horizontal ? 200 : __scrollbarExtent;
    height:orientation == Qt.Horizontal ? __scrollbarExtent : 200

    property int orientation : Qt.Horizontal
    property alias minimum: slider.minimumValue
    property alias maximum: slider.maximumValue
    property alias value: slider.value
    property variant __scrollbarrect : styleitem.subControlRect("slider");

    property bool upPressed;
    property bool downPressed;
    property bool __autoincrement: false;

    Timer { running: upPressed || downPressed; interval: 350 ; onTriggered: __autoincrement = true }
    Timer { running: __autoincrement; interval: 60 ; repeat: true ;
        onTriggered: upPressed ? decrement() : increment() }

    onPressed: {
        var control = styleitem.hitTest(mouseX,mouseY)
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
        if (value > maximum)
            value = maximum
    }

    function decrement() {
        value -= 30
        if (value < minimum)
            value = minimum
    }

    QStyleBackground {
        anchors.fill:parent

        style: QStyleItem {
            id:styleitem
            elementType:"scrollbar"
            sunken: upPressed | downPressed
            minimum:slider.minimumValue
            maximum:slider.maximumValue
            activeControl: upPressed ? "up" : downPressed ? "down" : ""
            value:slider.value
            horizontal:orientation == Qt.Horizontal
            enabled: parent.enabled
        }
    }

    Components.Slider {
        id:slider
        orientation:scrollbar.orientation
        leftMargin:16
        rightMargin:16
        anchors.fill:parent
        handle: Item{width:(maximum-minimum)/50.0; height:20}
        groove:null
        valueIndicator:null
        inverted:orientation != Qt.Horizontal
    }
}

