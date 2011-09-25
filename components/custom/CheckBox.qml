import QtQuick 1.1
import "./behaviors"

FocusScope {
    id: checkBox

    signal clicked
    property alias pressed: behavior.pressed
    property alias checked: behavior.checked
    property alias containsMouse: behavior.containsMouse

    property Component background: null
    property Item backgroundItem: backgroundLoader.item

    // implementation

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        property alias styledItem: checkBox
        sourceComponent: background
    }

    ButtonBehavior {
        id: behavior
        focus: true
        anchors.fill: parent
        checkable: true
        onClicked: {
            if (checkBox.activeFocusOnPress)
                checkBox.forceActiveFocus();
            checkBox.clicked();
        }
    }
    Keys.onSpacePressed: {clicked(); checked = !checked; }
}
