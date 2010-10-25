import Qt 4.7

QtObject {
    property Component background: defaultBackground
    property Component content: defaultContent

    property list<Component> elements: [
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
        },
        Component {
            id: defaultContent
            Item {
                property int minimumWidth: 40
                property int minimumHeight: 25
                width: Math.max(minimumWidth, row.width + 15 + 15) // add left and right margins
                height: Math.max(minimumHeight, row.height + 5 + 5) // add top and bottom margins

                Row {
                    id: row
                    spacing: 4
                    anchors.centerIn: parent
                    Image {
                        source: button.icon
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        color: !button.enabled ? "gray" : button.foregroundColor
                        anchors.verticalCenter: parent.verticalCenter
                        text: button.text
                    }
                }
            }

        }
    ]
}
