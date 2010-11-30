import Qt 4.7

QtObject {
    property int minimumWidth: 100
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
            BorderImage {
                anchors.fill: parent
                source: "../../images/lineedit_normal.png"
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
                smooth: true
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
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
                    Text {
                        anchors.verticalCenter: positiveBackground.verticalCenter
                        anchors.left: positiveBackground.left
                        anchors.leftMargin: 30
                        font.pixelSize: 14
                        font.bold: true
                        color: "#aaa"
                        text: "ON"
                        style: "Sunken"
                        styleColor: "white"
                    }

                    Rectangle {
                        id: negativeBackground
                        color: negativeHighlightColor
                        opacity: 0.8
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.horizontalCenter
                        anchors.right: parent.right

                    }
                    Text {
                        anchors.verticalCenter: negativeBackground.verticalCenter
                        anchors.right: negativeBackground.right
                        anchors.rightMargin: 30
                        font.pixelSize: 14
                        font.bold: true
                        color: "#aaa"
                        text: "OFF"
                        style: "Sunken"
                        styleColor: "white"
                    }
                }
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
                width: 50
                height: parent.height
                smooth: true
                source: pressed ? "../../images/switch_pressed.png" : "../../images/switch_normal.png"

                border.left: 4; border.top: 4
                border.right: 4; border.bottom: 4
            }
            Behavior on x { NumberAnimation { easing.type: Easing.OutCubic; duration: 200 } }
        }
    }
}
