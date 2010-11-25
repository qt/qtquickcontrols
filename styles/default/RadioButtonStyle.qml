import Qt 4.7

QtObject {

    property int minimumWidth: 32
    property int minimumHeight: 32

    property Component background:
    Component {
        Item{
            anchors.centerIn:parent
            Rectangle{
                anchors.fill:pixmap
                radius:width/2
                color:backgroundColor
            }

            Image{
                id:pixmap
                source: "../../images/radiobutton_normal.png"
                anchors.centerIn: parent
            }
        }
    }

    property Component checkmark: Component {
        Image {
            source: "../../images/radiobutton_check.png"
            anchors.centerIn:parent
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        }
    }
}
