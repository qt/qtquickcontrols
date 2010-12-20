import Qt 4.7
import "../../../components" as Components

Components.CheckBox{
    background: BorderImage {
        source: pressed ? "image://theme/meegotouch-button-checkbox-background-pressed":
                "image://theme/meegotouch-button-checkbox-background"
        border.top: 12
        border.bottom: 12
        border.left: 12
        border.right: 12
    }
    checkmark:Image{
        anchors.centerIn:parent
        source: pressed ? "image://theme/meegotouch-button-checkbox-checkmark-pressed" :
                "image://theme/meegotouch-button-checkbox-checkmark"
        Behavior on opacity { NumberAnimation{easing.type:Easing.OutCubic}}
    }
}

