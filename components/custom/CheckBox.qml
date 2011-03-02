import QtQuick 1.0
import "./behaviors"

Item {
    id: checkBox

    signal clicked
    property alias pressed: behavior.pressed
    property alias checked: behavior.checked
    property alias containsMouse: behavior.containsMouse

    property Component background: null
    property color backgroundColor: syspal.base
    property bool activeFocusOnPress: true

    // implementation

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        property alias styledItem: checkBox
        sourceComponent: background
    }

    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        checkable: true
        onClicked: {if (activeFocusOnPress)checkBox.focus = true; checkBox.clicked()}
    }

    SystemPalette { id: syspal }
}
