import QtQuick 1.0
import "custom" as Components
import "plugin"

Item {
    id: scrollbar

    property bool upPressed
    property bool downPressed
    property int orientation : Qt.Horizontal
    property alias minimumValue: slider.minimumValue
    property alias maximumValue: slider.maximumValue
    property int pageStep: (maximumValue-minimumValue)/4
    property alias value: slider.value
    property bool scrollToClickposition: styleitem.styleHint("scrollToClickPosition")

    width: orientation == Qt.Horizontal ? 200 : internal.scrollbarExtent
    height: orientation == Qt.Horizontal ? internal.scrollbarExtent : 200

    onValueChanged: internal.updateHandle()

    MouseArea {
        id: internal

        anchors.fill: parent

        property bool autoincrement: false
        property int scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
        property bool handlePressed

        // Update hover item
        onEntered: styleitem.activeControl = styleitem.hitTest(mouseX, mouseY)
        onExited: styleitem.activeControl = "none"
        onMouseXChanged: styleitem.activeControl = styleitem.hitTest(mouseX, mouseY)
        hoverEnabled: true

        property variant control
        property variant pressedX
        property variant pressedY
        property int oldPosition
        property int grooveSize

        Timer {
            running: upPressed || downPressed
            interval: 350
            onTriggered: internal.autoincrement = true
        }

        Timer {
            running: internal.autoincrement
            interval: 60
            repeat: true
            onTriggered: upPressed ? internal.decrement() : internal.increment()
        }

        onMousePositionChanged: {
            if (pressed && control === "handle") {
                //slider.positionAtMaximum = grooveSize
                if (!styleitem.horizontal)
                    slider.position = oldPosition + (mouseY - pressedY)
                else
                    slider.position = oldPosition + (mouseX - pressedX)
            }
        }

        onPressed: {
            control = styleitem.hitTest(mouseX,mouseY)
            scrollToClickposition = styleitem.styleHint("scrollToClickPosition")
            grooveSize =  styleitem.horizontal? styleitem.subControlRect("groove").width -
                                                styleitem.subControlRect("handle").width:
                                                    styleitem.subControlRect("groove").height -
                                                    styleitem.subControlRect("handle").height;
            if (control == "handle") {
                pressedX = mouseX
                pressedY = mouseY
                oldPosition = slider.position
            } else if (control == "up") {
                upPressed = true
            } else if (control == "down") {
                downPressed = true
            } else if (!scrollToClickposition){
                if (control == "upPage") {
                    scrollbar.value -= pageStep
                } else if (control == "downPage") {
                    scrollbar.value += pageStep
                }
            } else {
                slider.position = styleitem.horizontal ? mouseX - handleRect.width/2
                                                       : mouseY - handleRect.height/2
            }
        }

        onReleased: {
            autoincrement = false;
            if (upPressed) {
                upPressed = false;
                decrement()
            } else if (downPressed) {
                increment()
                downPressed = false;
            }
            control = ""
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

        QStyleItem {
            id: styleitem
            anchors.fill:parent
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

        property variant handleRect: Qt.rect(0,0,0,0)
        property variant grooveRect: Qt.rect(0,0,0,0)
        function updateHandle() {
            internal.handleRect = styleitem.subControlRect("handle")
            grooveRect = styleitem.subControlRect("groove");
        }

        RangeModel {
            id: slider
            minimumValue: 0.0
            maximumValue: 1.0
            value: 0
            stepSize: 0.0
            inverted: false
            positionAtMaximum: internal.grooveSize
        }
    }
}
