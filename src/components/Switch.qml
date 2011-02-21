import QtQuick 1.1
import "./styles/default" as DefaultStyles

Item {
    id: toggleSwitch    // "switch" is a reserved word

    signal clicked
    property bool pressed: mouseArea.pressed
    property bool checked: false
    property alias containsMouse: mouseArea.containsMouse

    property color switchColor: syspal.button
    property color backgroundColor: syspal.alternateBase
    property color positiveHighlightColor: syspal.highlight
    property color negativeHighlightColor: "transparent"
    property color textColor: syspal.text

    property Component groove: defaultStyle.groove
    property Component handle: defaultStyle.handle

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    // implementation

    implicitWidth: Math.max(minimumWidth, grooveLoader.item.implicitWidth)
    implicitHeight: Math.max(minimumHeight, grooveLoader.item.implicitHeight)

    onCheckedChanged: snapHandleIntoPlace();

    Loader {
        id: grooveLoader
        anchors.fill: parent
        property alias styledItem: toggleSwitch
        property real handleCenterX: handleLoader.item.x + (handleLoader.item.width/2)
        sourceComponent: groove
    }

    Loader {
        id: handleLoader
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        property alias styledItem: toggleSwitch
        sourceComponent: handle

        Component.onCompleted: item.x = checked ? mouseArea.drag.maximumX : mouseArea.drag.minimumX
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
        onCanceled: { snapHandleIntoPlace(); toggleSwitch.pressed = false; }   // mouse stolen e.g. by Flickable
        onReleased: {
            var wasChecked = checked;
            if (drag.active) {
                checked =  (handleLoader.item.x > (drag.maximumX - drag.minimumX)/2)
            } else if (toggleSwitch.pressed && enabled) { // No click if release outside area
                checked = !checked;
            }

            snapHandleIntoPlace();

            toggleSwitch.pressed = false
            if(checked != wasChecked)
                toggleSwitch.clicked();
        }
    }

    onWidthChanged: snapHandleIntoPlace()
    function snapHandleIntoPlace() {
        if(handleLoader.item)
            handleLoader.item.x = checked ? mouseArea.drag.maximumX : mouseArea.drag.minimumX;
    }

    DefaultStyles.SwitchStyle { id: defaultStyle }
    SystemPalette { id: syspal }
}
