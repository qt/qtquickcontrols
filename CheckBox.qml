import Qt 4.7
import "./behaviors"
import "./styles/default" as DefaultStyles

Item {
    id: checkbox

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight
    width: Math.max(minimumWidth, backgroundComponent.item.width)
    height: Math.max(minimumHeight, backgroundComponent.item.height)

    property alias containsMouse: behavior.containsMouse
    property Component background: defaultStyle.background
    property Component checkmark : defaultStyle.checkmark

    property color backgroundColor: "#fff";

    // Common API
    signal clicked
    property alias pressed: behavior.pressed
    property alias checked: behavior.checked

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
