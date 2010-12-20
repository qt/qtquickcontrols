import Qt 4.7
import "../../../components" as Components

Components.CheckBox{

    // Should size depend on contents, or should contents depend on size?

    background: BorderImage {
        width:32
        height:32
        source: pressed ? "image://theme/meegotouch-button-checkbox-background-pressed":
                "image://theme/meegotouch-button-checkbox-background"
        border.top: 12
        border.bottom: 12
        border.left: 12
        border.right: 12
    }

    checkmark:Image{
        smooth:true
        width:32
        height:32
        anchors.centerIn:parent
        visible: checked
        source: pressed ? "image://theme/meegotouch-button-checkbox-checkmark-pressed" :
                "image://theme/meegotouch-button-checkbox-checkmark"
        Behavior on opacity { NumberAnimation{easing.type:Easing.OutCubic}}
    }
}

