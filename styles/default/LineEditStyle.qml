import Qt 4.7

QtObject {
    property Component background: defaultBackground
    property Component content: defaultContent

    property list<Component> elements: [
        Component {
            id: defaultBackground
            Item {
                Rectangle{
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
            }
        },
        Component {
            id: defaultContent
            Item { anchors.fill: parent; anchors.margins: 4}
        }
    ]
}
