import Qt 4.7
import "./styles/default" as DefaultStyles

BasicButton {
    id: toggleSwitch    // "switch" is a reserved word

    checkable: true

    property alias containsMouse: mousearea.containsMouse

    property color backgroundColor: checked ? "#cef" : "#fff"
    property color textColor: "#333"

    property Component groove: defaultStyle.groove
    property Component handle: defaultStyle.handle

    preferredWidth: defaultStyle.preferredWidth
    preferredHeight: defaultStyle.preferredHeight

    property Component background : defaultStyle.background

    DefaultStyles.SwitchStyle { id: defaultStyle }

    Loader {
        id: grooveLoader;
        sourceComponent: groove
        anchors.fill:parent
        property real grooveLength: item.width
    }

    Loader {
        id: handleLoader
        sourceComponent: handle
        anchors.verticalCenter:parent.verticalCenter
    }

    MouseArea {
        id: mousearea
        enabled: toggleSwitch.enabled
        hoverEnabled: true
        anchors.fill: parent

        onPressed: toggleSwitch.pressed = true  // needed when hover is enabled
        onEntered: if(pressed && enabled) toggleSwitch.pressed = true
        onExited: toggleSwitch.pressed = false
        onReleased: {
            if (drag.active) {
                if (handleLoader.item.x > (drag.maximumX - drag.minimumX)/2)
                    checked = true
                else
                    checked = false
            } else if (toggleSwitch.pressed && enabled) { // No click if release outside area
                toggleSwitch.pressed  = false
                checked = !checked;
                toggleSwitch.clicked()
            }
            handleLoader.item.x = checked ? drag.maximumX : drag.minimumX
            toggleSwitch.clicked()
        }

        drag.axis: Drag.XAxis
        drag.minimumX:0
        drag.maximumX:toggleSwitch.width - handleLoader.item.width
        drag.target:handleLoader.item
    }
}
