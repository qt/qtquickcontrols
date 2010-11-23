import Qt 4.7

QtObject {

    property int preferredWidth: 90
    property int preferredHeight: 32

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 8
    property int bottomMargin: 8

    property Component background:
    Component {
        id: defaultBackground
        Item {
            Rectangle{
                x: 1; y: 1
                width: parent.width-2
                height: parent.height-2
                color: button.backgroundColor
                radius: 5
            }

            BorderImage {
                anchors.fill: parent
                smooth: true
                source: button.pressed ? "images/button_pressed.png" : "images/button_normal.png"
                border.left: 6; border.top: 6
                border.right: 6; border.bottom: 6
            }

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: button.checked ? 0.4 : 0
            }
        }
    }

    property Component label:
    Component {
        id: defaultLabel
        Item {
            width:row.width
            height:row.height
            Row {
                id: row
                spacing: 4
                anchors.centerIn: parent
                Image {
                    source: button.iconSource
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    color: !button.enabled ? "gray" : button.textColor
                    anchors.verticalCenter: parent.verticalCenter
                    text: button.text
                }
            }
        }

    }
}
