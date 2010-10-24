import Qt 4.7

Button{
    id:button

    width: 120
    height: 28

    background: defaultbackground
    content: defaultlabel

    Component {
        id:defaultbackground
        Item {
            Rectangle{
                color:backgroundColor
                radius: 5
                x:1
                y:1
                width:parent.width-2
                height:parent.height-2
            }

            BorderImage {
                id: backgroundimage
                smooth:true
                anchors.left:parent.left
                anchors.top:parent.top
                anchors.bottom: parent.bottom

                source: "images/lineedit_normal.png"
                width: 24; height: 24
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
            }

            Image {
                opacity:checked ? 1 : 0
                source:"images/checkbox_check.png"
                Behavior on opacity{NumberAnimation {duration: 150; easing.type:Easing.OutCubic}}
                anchors.centerIn:parent
                anchors.verticalCenterOffset:1
                anchors.horizontalCenterOffset:1
            }
        }
    }

    Component {
        id:defaultlabel
        Item {
            width:layout.width
            height:layout.height

            anchors.bottom:parent.bottom
            anchors.margins:4
            Row {
                spacing:4
                anchors.bottom:parent.bottom
                id:layout
                Image { source:button.icon}
                Text {
                    color:button.foregroundColor;
                    font.pixelSize:14
                    text:button.text
                    y:4
                }
            }
        }
    }
}
