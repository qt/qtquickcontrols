import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: toggleSwitch    // "switch" is a reserved word

    width: Math.max(100, labelComponent.item.width + 2*10)
    height: Math.max(32, labelComponent.item.height + 2*4)

    signal clicked

    property alias hover: mousearea.containsMouse
    property bool pressed: false
    property bool checkable: true
    property bool checked: false

    property string text
    property string icon
    property int labelSpacing:8

    property color backgroundColor: checked ? "#cef" : "#fff"
    property color foregroundColor: "#333"

//    property url fontFile: ""
//    FontLoader { id: font; source: fontFile }

    property Component background : defaultStyle.background
    property Component content : defaultStyle.content
    DefaultStyles.SwitchStyle { id: defaultStyle }

    Loader { // background
        id: backgroundComponent
        anchors.fill: parent
        sourceComponent: background
        opacity: enabled ? 1 : 0.8
    }

    Loader { // content
        id: labelComponent
        anchors.left: backgroundComponent.right
        anchors.leftMargin: labelSpacing
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: content
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
                if (checkable)
                    checked = !checked;
                toggleSwitch.clicked()
            }
        }
    }
}
