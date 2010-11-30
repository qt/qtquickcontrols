import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: toggleSwitch    // "switch" is a reserved word

    property bool checked: false
    signal clicked

    property bool pressed: mouseArea.pressed
    property alias containsMouse: mouseArea.containsMouse

    property color backgroundColor: "#fff"
    property color positiveHighlightColor: "blue"
    property color negativeHighlightColor: "transparent"

    property Component groove: defaultStyle.groove
    property Component handle: defaultStyle.handle

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight
    width: Math.max(minimumWidth, grooveLoader.item.width)
    height: Math.max(minimumHeight, grooveLoader.item.height)

    Loader {
        id: grooveLoader
        anchors.fill: parent
        sourceComponent: groove
        property real handleCenterX: handleLoader.item.x + (handleLoader.item.width/2)
    }

    Loader {
        id: handleLoader
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        sourceComponent: handle
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        drag.axis: Drag.XAxis
        drag.minimumX: 0
        drag.maximumX: toggleSwitch.width - handleLoader.item.width
        drag.target: handleLoader.item

        onPressed: toggleSwitch.pressed = true  // needed when hover is enabled
        onEntered: if (toggleSwitch.pressed && enabled) toggleSwitch.pressed = true
        onExited: { __snapHandleIntoPlace(); toggleSwitch.pressed = false }
        onCanceled: { __snapHandleIntoPlace(); toggleSwitch.pressed = false; }   // mouse stolen e.g. by Flickable
        onReleased: {
            var wasChecked = checked;
            if (drag.active) {
                checked =  (handleLoader.item.x > (drag.maximumX - drag.minimumX)/2)
            } else if (toggleSwitch.pressed && enabled) { // No click if release outside area
                checked = !checked;
            }

            __snapHandleIntoPlace();

            toggleSwitch.pressed = false
            if(checked != wasChecked)
                toggleSwitch.clicked();
        }
    }

    onWidthChanged: __snapHandleIntoPlace()
    function __snapHandleIntoPlace() {
        if(handleLoader.item)
            handleLoader.item.x = checked ? mouseArea.drag.maximumX : mouseArea.drag.minimumX;
    }
    DefaultStyles.SwitchStyle { id: defaultStyle }
}
