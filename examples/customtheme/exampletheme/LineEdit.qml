import Qt 4.7
import "../../../" as Components

Components.LineEdit {
    leftMargin:12
    rightMargin:12
    minimumWidth:200

    background: BorderImage {
        height:30
        width:parent.width
        source: "images/edit_normal.png"
        border.top:6
        border.bottom:6
        border.left:6
        border.right:8
    }
}
