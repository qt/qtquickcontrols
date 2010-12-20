import QtQuick 1.0
import "../../../components" as Components

Components.CheckBox{
    background: BorderImage {
        source: "images/edit_normal.png"
        border.top:6
        border.bottom:6
        border.left:6
        border.right:8
    }
    checkmark:Image{
        anchors.centerIn:parent
        source: "images/checkbox_check.png"
        Behavior on opacity { NumberAnimation{easing.type:Easing.OutCubic}}
    }
}

