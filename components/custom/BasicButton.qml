import QtQuick 1.1
import "./behaviors"    // ButtonBehavior
import "./styles/default" as DefaultStyles

Item {
    id: button

    signal clicked
    property alias pressed: behavior.pressed
    property alias containsMouse: behavior.containsMouse
    property alias checkable: behavior.checkable  // button toggles between checked and !checked
    property alias checked: behavior.checked

    property Component background: defaultStyle.background

    property color backgroundColor: syspal.button
    property color textColor: syspal.text;

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight
    property bool activeFocusOnPress: true

    // implementation

    property string __position: "only"
    implicitWidth: Math.max(minimumWidth, backgroundLoader.item.width)
    implicitHeight: Math.max(minimumHeight, backgroundLoader.item.height)

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: background
        property alias styledItem: button
        property alias position: button.__position
    }

    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        onClicked: button.clicked()
        onPressedChanged: if (activeFocusOnPress) button.focus = true
    }

    DefaultStyles.BasicButtonStyle { id: defaultStyle }
    SystemPalette { id: syspal }
}
