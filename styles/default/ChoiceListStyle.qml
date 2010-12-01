import Qt 4.7

QtObject {

    property int minimumWidth: 200
    property int minimumHeight: 32

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 34
    property int bottomMargin: 8

    property Component background:
    Component {
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
                source: choiceList.pressed ? "../../images/button_pressed.png" : "../../images/button_normal.png"
                width: 80; height: 24
                border.left: 3; border.top: 3
                border.right: 3; border.bottom: 3
                Image {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 7
                    anchors.rightMargin: 10
                    opacity: enabled ? 1 : 0.3
                    source:"../../images/spinbox_up.png"
                }
                Image {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 7
                    anchors.rightMargin: 10
                    opacity: enabled ? 1 : 0.3
                    source:"../../images/spinbox_down.png"
                }
            }
        }
    }

    property Component popupFrame:
    Component {
        Item {

            Behavior on opacity { NumberAnimation { easing.type: Easing.OutQuad; duration: 250 }}

            property int minimumWidth: 200

            property int leftMargin : 8
            property int topMargin: 8
            property int rightMargin: 30
            property int bottomMargin: 8

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
                source: "../../images/button_normal.png"
                width: 80; height: 24
                border.left: 5; border.top: 5
                border.right: 5; border.bottom: 5
            }
        }
    }

    property Component label : Component {
        Row {
            id: row
            spacing: 6
            anchors.centerIn: parent
            Text {
                color: textColor
                anchors.verticalCenter: parent.verticalCenter
                text: model.get(currentIndex).content
                opacity: parent.enabled ? 1 : 0.5
            }
        }
    }

    property Component listItem: Component {
        Item {
            width: styledItem.width
            height: Math.max(itemText.height, 28)
            Text {
                id: itemText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 6

                color: styledItem.textColor
                anchors.margins: 10
                text: model.get(index).content  // list properties can't be automatically be added to the scope, so use get()
            }
        }
    }

    property Component listHighlight: Component {
        Rectangle {
            color: "#fa1"
            border.color: Qt.darker(color)
            radius:2
            smooth:true
            opacity:0.7
        }
    }


    property Component hints: Component {
        Item {
            property color textColor: "#555"
            property color backgroundColor: "white"
        }
    }
}
