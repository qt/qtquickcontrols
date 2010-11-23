import Qt 4.7
import "./behaviors"
import "./styles/default" as DefaultStyles

Item {
    id: button

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

    property color backgroundColor: "#fff";
    property color textColor: "#222";


    Loader {
        id:backgroundComponent
        anchors.fill: parent
        sourceComponent: background
    }

    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        onClicked: button.clicked()
    }

    DefaultStyles.BasicButtonStyle { id: defaultStyle }
}
