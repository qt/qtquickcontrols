import Qt 4.7

QtObject {
    property Component background: defaultBackground
    property Component content: defaultLabel
    property Component listItem: defaultListItem
    property Component listHighligth: defaultListHighlight

    property int minimumWidth: 90
    property int minimumHeight: 32

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 8
    property int bottomMargin: 8

    property list<Component> elements: [
        Component {
            id: defaultBackground
            Item {
                opacity: enabled ? 1 : 0.8
                Rectangle{
                    x: 1
                    y: 1
                    width: parent.width-2
                    height: parent.height-2
                    color: backgroundColor
                    radius: 5
                }
                BorderImage {
                    anchors.fill: parent
                    id: backgroundimage
                    smooth: true
                    source: comboBox.pressed ? "../../images/button_pressed.png" : "../../images/button_normal.png"
                    width: 80; height: 24
                    border.left: 3; border.top: 3
                    border.right: 3; border.bottom: 3
                    Image {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.topMargin: 7
                        anchors.rightMargin: 7
                        opacity: enabled ? 1 : 0.3
                        source:"../../images/spinbox_up.png"
                    }
                    Image {
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.bottomMargin: 7
                        anchors.rightMargin: 7
                        opacity: enabled ? 1 : 0.3
                        source:"../../images/spinbox_down.png"
                    }
                }
            }
        },
        Component {
            id: defaultLabel
            Item {
                Row {
                    spacing: 6
                    anchors.centerIn: parent
                    id: row
//                    Image { source:combobox.icon; anchors.verticalCenter:parent.verticalCenter}
                    anchors.margins: 20
                    Text {
                        id: label
//                        font: comboBox.font
                        color: comboBox.foregroundColor
                        anchors.verticalCenter: parent.verticalCenter
                        text: comboBox.model.get(comboBox.currentIndex).content
                        opacity:parent.enabled ? 1 : 0.5
                    }
                }
            }
        },
        Component {
            id: defaultListItem
            Rectangle {
                width: row.width
                height: row.height
                color: index % 2 == 0 ? "yellow" : "blue"
                Row {
                    id: row
                    spacing: 5
                    Text {
//                        font.pixelSize: mx.fontSize
//                        color: mx.fontColor
                        text: model.content
                    }
//                    Image {
//                        source: icon
//                        anchors.verticalCenter: parent.verticalCenter
//                        height: wrapper.height - 10
//                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: { comboBox.currentIndex = index; popOut.opacity = 0; }
                }
            }
        },
        Component {
            id: defaultListHighlight
            Rectangle {
                color: "#cccccc"
                x: 1
                width: parent.width-2
            }
        }
    ]
}
