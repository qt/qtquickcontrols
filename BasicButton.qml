import Qt 4.7
import "./behaviors"
import "./styles/default" as DefaultStyles

Item {
    id: button

    property int preferredWidth: defaultStyle.preferredWidth
    property int preferredHeight: defaultStyle.preferredHeight
    width: Math.max(preferredWidth, backgroundComponent.item.width)
    height: Math.max(preferredHeight, backgroundComponent.item.height)

    signal clicked
    property alias pressed: behavior.pressed
    property alias containsMouse: behavior.containsMouse
    property alias checkable: behavior.checkable  // button toggles between checked and !checked
    property alias checked: behavior.checked

    property Component background: defaultStyle.background

    property color backgroundColor: "#fff";
    property color textColor: "#222";

    DefaultStyles.BasicButtonStyle { id: defaultStyle }
    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        onClicked: button.clicked()
    }

    Loader {    // background
        id:backgroundComponent
        anchors.fill: parent
        sourceComponent: background
    }
}
