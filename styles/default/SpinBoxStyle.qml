import Qt 4.7

QtObject {

    property int minimumWidth: 200
    property int minimumHeight: 25

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 8
    property int bottomMargin: 8

    property Component background:
    Component {
        id: defaultBackground
        Item {
            Rectangle {
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
                source: "../../images/lineedit_normal.png"
                border.left: 6; border.top: 6
                border.right: 50; border.bottom: 6
            }
        }
    }

    property Component up:
    Component {
        id: defaultUp
        Item {
            anchors.right: parent.right
            anchors.top: parent.top
            width: 24
            height: parent.height/2
            Image {
                anchors.left: parent.left;
                anchors.top: parent.top;
                anchors.topMargin: 7
                opacity: (upEnabled && enabled) ? (upPressed ? 1 : 0.8) : 0.3
                source: "../../images/spinbox_up.png"
            }
        }
    }

    property Component down:
    Component {
        id: defaultDown
        Item {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 24
            height: parent.height/2
            Image {
                anchors.left: parent.left;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 7
                opacity: (downEnabled && enabled) ? (downPressed ? 1 : 0.8) : 0.3
                source: "../../images/spinbox_down.png"
            }
        }
    }
}
