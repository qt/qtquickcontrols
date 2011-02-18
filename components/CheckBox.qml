import QtQuick 1.1
import "./behaviors"
import "./styles/default" as DefaultStyles

Item {
    id: checkBox

    signal clicked
    property alias pressed: behavior.pressed
    property alias checked: behavior.checked
    property alias containsMouse: behavior.containsMouse

    property Component background: defaultStyle.background
    property Component checkmark: defaultStyle.checkmark

    property color backgroundColor: syspal.base

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    // implementation

    implicitWidth: minimumWidth
    implicitHeight: minimumHeight

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        property alias styledItem: checkBox
        sourceComponent: background
    }

    Loader {
        id: checkmarkLoader
        anchors.centerIn: parent
        property alias styledItem: checkBox
        sourceComponent: checkmark
    }

    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        checkable: true
        onClicked: checkBox.clicked()
    }

    DefaultStyles.CheckBoxStyle { id: defaultStyle }
    SystemPalette { id: syspal }
}
