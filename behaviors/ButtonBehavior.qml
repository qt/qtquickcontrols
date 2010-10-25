import Qt 4.7

Item {
    id: behavior

    signal clicked
    property bool pressed: false
    property bool checkable: false
    property bool checked: false
    property bool triState: false

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onEntered: if(enabled) behavior.pressed = true  // handles clicks as well
        onExited: behavior.pressed = false
        onReleased: {
            if(behavior.pressed && behavior.enabled) { // No click if release outside area
                behavior.pressed = false
                if(behavior.checkable)
                    behavior.checked = !behavior.checked;
                behavior.clicked()
            }
        }
    }
}
