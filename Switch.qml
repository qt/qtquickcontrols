import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: toggleSwitch    // "switch" is a reserved word

    property int preferredWidth: defaultStyle.preferredWidth
    property int preferredHeight: defaultStyle.preferredHeight
    width: Math.max(preferredWidth, grooveLoader.item.width)
    height: Math.max(preferredHeight, grooveLoader.item.height)

    signal clicked
    property bool pressed: mousearea.pressed
    property alias containsMouse: mousearea.containsMouse
    property bool checked: false

    property Component groove: defaultStyle.groove
    property Component handle: defaultStyle.handle

    property color backgroundColor: checked ? "#cef" : "#fff"
    property color textColor: "#333"

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

        drag.axis: Drag.XAxis
        drag.minimumX:0
        drag.maximumX:toggleSwitch.width - handleLoader.item.width
        drag.target:handleLoader.item

        onPressed: toggleSwitch.pressed = true  // needed when hover is enabled
        onEntered: if (toggleSwitch.pressed && enabled) toggleSwitch.pressed = true
        onExited: toggleSwitch.pressed = false
        onReleased: {
            if(toggleSwitch.pressed && enabled) { // No click if release outside area
                toggleSwitch.pressed = false
                checked = !checked;
            }
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
    }

    DefaultStyles.SwitchStyle { id: defaultStyle }
}
