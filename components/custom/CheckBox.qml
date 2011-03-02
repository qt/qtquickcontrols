import QtQuick 1.1
import "./behaviors"

Item {
    id: checkBox

    signal clicked
    property alias pressed: behavior.pressed
    property alias checked: behavior.checked
    property alias containsMouse: behavior.containsMouse

    property Component background: null

    property color backgroundColor: syspal.base

    property int minimumWidth: 0
    property int minimumHeight: 0

    property bool activeFocusOnPress: true

    // implementation

    implicitWidth: minimumWidth
    implicitHeight: minimumHeight

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
