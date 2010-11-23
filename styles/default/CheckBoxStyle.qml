import Qt 4.7

QtObject {

    property int minimumWidth: 32
    property int minimumHeight: 32

    property Component background:
    Component {
        Item {
            Rectangle{
                anchors.fill: backgroundimage
                color: backgroundColor
                radius: 5
            }

            BorderImage {
                id: backgroundimage
                width: parent.height;
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                source: "../../images/lineedit_normal.png"
                smooth: true
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
            }
        }
    }

    property Component checkmark: Component {
        Image {
            source: "../../images/checkbox_check.png"
            anchors.verticalCenterOffset:1
            anchors.horizontalCenterOffset:1
            anchors.centerIn:parent
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        }
    }
}
