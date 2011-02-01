import QtQuick 1.1

QtObject {
    property int minimumWidth: 80
    property int minimumHeight: 32

    property Component groove: Component {
        Item {
            opacity: enabled ? 1 : 0.7
            Rectangle { // Background center fill
                anchors.fill: parent
                anchors.margins: 1
                radius: 5
                color: backgroundColor
            }

            Item { // Clipping container of the positive and negative groove highlight
                anchors.fill: parent
                anchors.margins: 2
                clip: true

                Item { // The highlight item is twice the width of there switch, clipped by its parent,
                       // and sliding back and forth keeping the center under the handle
                    height: parent.height
                    width: 2*parent.width
                    x: handleCenterX-parent.width-parent.anchors.leftMargin

                    Rectangle { // positive background highlight
                        color: positiveHighlightColor
                        opacity: 0.8
                        anchors.top: parent.top; anchors.bottom: parent.bottom
                        anchors.left: parent.left; anchors.right: parent.horizontalCenter
                    }
                    Rectangle { // negative background highlight
                        color: negativeHighlightColor
                        opacity: 0.8
                        anchors.top: parent.top; anchors.bottom: parent.bottom
                        anchors.left: parent.horizontalCenter; anchors.right: parent.right
                    }
                }
            }

            BorderImage { // Rounded border
                anchors.fill: parent
                source: "images/lineedit_normal.png"
                border { left: 6; right: 6; top: 3; bottom: 3 }
                smooth: true
            }
        }
    }

    property Component handle: Component {
        Item {
            width: 42
            Rectangle { // center fill
                anchors.fill: parent
                anchors.margins: 1
                radius: 5
                color: switchColor
            }
            BorderImage {
                anchors.fill: parent
                opacity: enabled ? 1 : 0.7
                smooth: true
                source: pressed ? "images/button_pressed.png" : "images/button_normal.png"
                border { left: 4; top: 4; right: 4; bottom: 4 }
            }
            Behavior on x { NumberAnimation { easing.type: Easing.OutCubic; duration: 200 } }
        }
    }
}
