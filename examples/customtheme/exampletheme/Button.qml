import Qt 4.7
import "../../../" as Components

Components.Button {
    leftMargin:12
    rightMargin:1
    minimumWidth:100

    background: BorderImage {
        source: pressed ? "images/button_pressed.png" :
                "images/button_normal.png"
        border.top:8
        border.bottom:8
        border.left:8
        border.right:8
    }
}

