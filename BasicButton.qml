import Qt 4.7
import "./behaviors"
import "./styles/default" as DefaultStyles

Item {
    id: button

    width: contentComponent.item.width
    height: contentComponent.item.height

    signal clicked
    property alias pressed: behavior.pressed
    property alias containsMouse: behavior.containsMouse
    property alias checkable: behavior.checkable  // button toggles between checked and !checked
    property alias checked: behavior.checked

    property Component background: defaultStyle.background
    property Component content: defaultStyle.content

    property color backgroundColor: "#fff";
    property color foregroundColor: "#222";

    DefaultStyles.BasicButtonStyle { id: defaultStyle }
    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        onClicked: button.clicked()
    }

    Loader {    // background
        anchors.fill: parent
        sourceComponent: background
    }

    Loader {    // content
        id: contentComponent
        anchors.centerIn: parent
        sourceComponent: content
    }
}
