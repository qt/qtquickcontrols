import Qt 4.7

QtObject {
    property Component background: defaultBackground
    property Component content: defaultContent

    property list<Component> elements: [
        Component {
            id: defaultBackground
            Item {
                Rectangle{
                    anchors.fill: backgroundimage
                    color: backgroundColor
                    radius: 5
                }

                BorderImage {
                    id: backgroundimage
                    width: parent.height;
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    source: "../../images/lineedit_normal.png"
                    smooth: true
                    border.left: 6; border.top: 3
                    border.right: 6; border.bottom: 3
                }

                Image {
                    anchors.centerIn: backgroundimage
                    anchors.verticalCenterOffset: 1
                    anchors.horizontalCenterOffset: 1
                    opacity: checked ? (enabled ? 1 : 0.5) : 0
                    source: "../../images/checkbox_check.png"
                    Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                }
            }
        },
        Component {
            id: defaultContent
            Item {
                width: 16
                height: 16
                anchors.bottom: parent.bottom
                anchors.margins: 4
            }
        }
    ]
}
