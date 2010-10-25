import Qt 4.7

QtObject {
    property Component background: defaultBackground
    property Component content: defaultContent

    property list<Component> elements: [
        Component {
            id: defaultBackground
            Rectangle{
                width: button.width-2
                height: button.height-2
                anchors.centerIn: parent
                color: button.backgroundColor
                radius: width/2
            }
        },
        Component {
            id: defaultContent
            Item {
                width: 20
                height: 20
                anchors.centerIn: parent
                Rectangle {
                    width: 10
                    height: 10
                    anchors.centerIn: parent
                    color: button.pressed || !button.enabled ? "gray" : "black"
                    radius: width/2
                    opacity: button.checked || button.pressed ? 1 : 0
                }
            }
        }
    ]
}
