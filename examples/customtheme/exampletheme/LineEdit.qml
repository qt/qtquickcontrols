import QtQuick 1.0
import "../../../components" as Components

Components.TextField {
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
