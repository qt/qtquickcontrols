import Qt 4.7
import "./behaviors"
import "./styles/default" as DefaultStyles

Item {
    id: checkbox

    property int preferredWidth: defaultStyle.preferredWidth
    property int preferredHeight: defaultStyle.preferredHeight
    width: Math.max(preferredWidth, backgroundComponent.item.width)
    height: Math.max(preferredHeight, backgroundComponent.item.height)

    signal clicked
    property alias pressed: behavior.pressed
    property alias containsMouse: behavior.containsMouse
    property alias checked: behavior.checked

    property Component background: defaultStyle.background
    property Component checkmark : defaultStyle.checkmark

    property color backgroundColor: "#fff";

    function setCheckItemOpacity() {
        if (checkComponent.item != undefined)
            checkComponent.item.opacity = checked ? (enabled ? 1 : 0.5) : 0
    }

    Loader {
        id:backgroundComponent
        anchors.fill: parent
        sourceComponent: background
    }

    Loader {
        id: checkComponent
        anchors.centerIn: parent
        sourceComponent: checkmark
        onLoaded: setCheckItemOpacity()
    }

    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        onCheckedChanged: setCheckItemOpacity()
        checkable:true
    }

    DefaultStyles.CheckBoxStyle { id: defaultStyle }
}
