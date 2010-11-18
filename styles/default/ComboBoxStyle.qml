import Qt 4.7

QtObject {

    property int preferredWidth: 90
    property int preferredHeight: 32

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 30
    property int bottomMargin: 8

    property Component background:
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
    }

    property Component label : Component {

        Row {
            id: row
            spacing: 6
            anchors.centerIn: parent
            onWidthChanged: preferredWidth = Math.max(40, row.width+10+10)    //mm workaround for lacking support for defining bindings in javascript, see above
            onHeightChanged: preferredHeight = Math.max(25, row.height+6+6)
            Text {
                color: textColor
                anchors.verticalCenter: parent.verticalCenter
                text: model.get(currentIndex).content
                opacity: parent.enabled ? 1 : 0.5
            }
        }
    }

    property Component listItem: Component {
        Rectangle {
            width: parent.width
            height: row.height
            color: index % 2 == 0 ? "yellow" : "blue"
            Row {
                id: row
                spacing: 5
                Text {
                    anchors.margins: 10
                    text: model.content
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: { parent.currentIndex = index; popOut.opacity = 0; }
            }
        }
    }

    property Component listHighlight: Component {
        Rectangle {
            color: "#cccccc"
            x: 1
            width: parent.width-2
        }
    }


    property Component hints: Component {
        QtObject{
            property color textColor: "blue"
            property color backgroundColor: "yellow"
        }
    }

}
