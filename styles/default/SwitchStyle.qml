import Qt 4.7

QtObject {

    property variant minimumWidth: 100
    property variant minimumHeight: 32

    property Component groove: Component {
        Item {
            Rectangle {
                x: 1
                y: 1
                width: parent.width-2
                height: parent.height-2
                radius: 5
                color: backgroundColor
            }
            BorderImage {
                anchors.fill: parent
                id: backgroundimage
                smooth: true
                source: "../../images/lineedit_normal.png"
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
            }
            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.Center
                width: parent.width/2
                font.pixelSize: 14
                font.bold: true
                color: "#aaa"
                text: "OFF"
                style: "Sunken"
                styleColor: "white"
                opacity: checked ? 0 : (enabled ? 1 : 0.5)
                Behavior on opacity { NumberAnimation { duration: 60 } }
            }
            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width/2
                horizontalAlignment: Text.Center
                font.pixelSize: 14
                font.bold: true
                color: "#aaa"
                text: "ON"
                style: "Sunken"
                styleColor: "white"
                opacity: checked ? (enabled ? 1 : 0.5) : 0
                Behavior on opacity { NumberAnimation { duration: 60 } }
            }
        }
    }

    property Component handle: Component {
        BorderImage {
            width: 50
            height:32
            smooth: true
            source: pressed ? "../../images/switch_pressed.png" : "../../images/switch_normal.png"

            border.left: 4; border.top: 4
            border.right: 4; border.bottom: 4
            Behavior on x {NumberAnimation{easing.type: Easing.OutCubic; duration:100}}
        }
    }
}
