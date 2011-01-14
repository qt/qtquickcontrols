import QtQuick 1.0
import "./behaviors"    // ButtonBehavior
import "./styles/default" as DefaultStyles

Item {
    id: button
    SystemPalette{id:syspal}

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight
    width: Math.max(minimumWidth, backgroundComponent.item.width)
    height: Math.max(minimumHeight, backgroundComponent.item.height)

    signal clicked
    property alias pressed: behavior.pressed
    property alias containsMouse: behavior.containsMouse
    property alias checkable: behavior.checkable  // button toggles between checked and !checked
    property alias checked: behavior.checked

    property Component background: defaultStyle.background

    property color backgroundColor: syspal.button
    property color textColor: syspal.text;
    property string __position: "only"

    Loader {
        id:backgroundComponent
        anchors.fill: parent
        sourceComponent: background
        property Item styledItem:button
        property alias position:button.__position
    }

    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        onClicked: button.clicked()
    }

    DefaultStyles.BasicButtonStyle { id: defaultStyle }
}
