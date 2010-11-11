import Qt 4.7
import "./styles/default" as DefaultStyles

BasicButton {
    id: toggleSwitch    // "switch" is a reserved word

    property bool checked: false

    signal clicked
    property alias containsMouse: mousearea.containsMouse
    property bool pressed: false

    property color backgroundColor: checked ? "#cef" : "#fff"
    property color foregroundColor: "#333"

    minimumWidth: defaultStyle.minimumWidth
    minimumHeight: defaultStyle.minimumHeight

    property Component background : defaultStyle.background
    DefaultStyles.SwitchStyle { id: defaultStyle }

    Loader { // background
        id: backgroundComponent
        anchors.fill: parent
        sourceComponent: background
        opacity: enabled ? 1 : 0.8
    }

    MouseArea {
        id: mousearea
        enabled: toggleSwitch.enabled
        hoverEnabled: true
        anchors.fill: parent
        onMousePositionChanged:  {
            if(pressed) {
                // Implement me
            }
        }

        onPressed: toggleSwitch.pressed = true  // needed when hover is enabled
        onEntered: if(pressed && enabled) toggleSwitch.pressed = true
        onExited: toggleSwitch.pressed = false
        onReleased: {
            if(toggleSwitch.pressed && enabled) { // No click if release outside area
                toggleSwitch.pressed  = false
                checked = !checked;
                toggleSwitch.clicked()
            }
        }
    }
}
