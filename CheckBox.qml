import Qt 4.7
import "./styles/default" as DefaultStyles

BasicButton {
    id: button

    background: defaultStyle.background
    checkable: true

    property Component checkmark : defaultStyle.checkmark

    preferredWidth: defaultStyle.preferredWidth
    preferredHeight: defaultStyle.preferredHeight

    DefaultStyles.CheckBoxStyle { id: defaultStyle }

    function setCheckItemOpacity() {
        if (checkComponent.item != undefined)
            checkComponent.item.opacity = checked ? (enabled ? 1 : 0.5) : 0
    }

    Loader {
        id: checkComponent
        anchors.centerIn: parent
        sourceComponent: checkmark
        onLoaded: setCheckItemOpacity()
    }

    onCheckedChanged: setCheckItemOpacity()
}
