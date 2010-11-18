import Qt 4.7

QtObject {
    property Component background: defaultBackground

    property variant preferredWidth: 100
    property variant preferredHeight: 32

    property list<Component> elements: [
        Component {
            id: defaultBackground
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
                BorderImage {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    x: checked ? parent.width-width : 0
                    width: parent.width/2
                    smooth: true
                    source: pressed ? "../../images/switch_pressed.png" : "../../images/switch_normal.png"
                    height: parent.height
                    border.left: 4; border.top: 4
                    border.right: 4; border.bottom: 4
                    Behavior on x { NumberAnimation { duration: 60 ; easing.type: "InOutCirc"}
                    }
                }
            }
        }
    ]
}
