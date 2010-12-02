import Qt 4.7

QtObject {
    property int minimumWidth: 80
    property int minimumHeight: 32

    property Component groove: Component {
        Item {
            opacity: enabled ? 1 : 0.7
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 5
                color: backgroundColor
            }

            Item {
                anchors.fill: parent
                anchors.margins: 2
                clip: true

                Item {
                    height: parent.height
                    width: 2*parent.width
                    x: handleCenterX-parent.width-parent.anchors.leftMargin

                    Rectangle {
                        id: positiveBackground
                        color: positiveHighlightColor
                        opacity: 0.8
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.horizontalCenter
                    }
                }
            }
            BorderImage {
                anchors.fill: parent
                source: "../../images/lineedit_normal.png"
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
                smooth: true
            }

        }
    }

    property Component handle: Component {
        Item {
            width: borderImage.width

            Rectangle { // center fill
                anchors.fill: parent
                anchors.margins: 1
                radius: 5
                color: backgroundColor  //mm Change to something else?
            }
            BorderImage {
                id: borderImage
                opacity: enabled ? 1 : 0.7
                width: 42
                height: parent.height
                smooth: true
                source: pressed ? "../../images/button_pressed.png" : "../../images/button_normal.png"

                border.left: 4; border.top: 4
                border.right: 4; border.bottom: 4
            }
            Behavior on x { NumberAnimation { easing.type: Easing.OutCubic; duration: 200 } }
        }
    }
}
