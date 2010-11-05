import Qt 4.7

QtObject {
    property Component background: defaultBackground

    property int minimumWidth: 200
    property int minimumHeight: 25

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 8
    property int bottomMargin: 8

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
        }
    ]
}
