import Qt 4.7
import "./behaviors"
import "./styles/default" as DefaultStyles

Item {
    id: button

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: Math.max(minimumWidth,
                    contentComponent.item.width + leftMargin + rightMargin)

    height: Math.max(minimumHeight,
                     contentComponent.item.height + topMargin + bottomMargin)

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

    Loader {    // background        id:background
        anchors.fill: parent
        sourceComponent: background
    }

    Loader {    // content
        id: contentComponent
        anchors.fill: parent
        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
        anchors.topMargin: topMargin
        anchors.bottomMargin: bottomMargin
        sourceComponent: content
    }
}
