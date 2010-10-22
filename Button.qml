import Qt 4.7

Item {
    id:button

    width: Math.max(80, labelComponent.item.width + 2*10)
    height: Math.max(32, labelComponent.item.height + 2*4)

    clip:true
    signal clicked
    property bool pressed : mousearea.pressed;
    property Component background : defaultbackground
    property Component content : defaultlabel
    property string text
    property string icon

    property color backgroundColor: "#fff";
    property color foregroundColor: "#222";

    // background
    Loader {
        id:backgroundComponent
        anchors.fill:parent
        sourceComponent:background
    }

    // content
    Loader {
        id:labelComponent
        anchors.centerIn: parent
        sourceComponent:content
    }

    MouseArea {
        id:mousearea
        anchors.fill:parent
        onPressed: button.clicked
    }

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
                anchors.fill:parent
                id: backgroundimage
                smooth:true
                source: pressed ? "images/button_pressed.png" : "images/button_normal.png"
                width: 80; height: 24
                border.left: 3; border.top: 3
                border.right: 3; border.bottom: 3
            }
        }
    }

    Component {
        id:defaultlabel
        Item {
            width:layout.width
            height:layout.height
            anchors.margins:4
            Row {
                spacing:4
                anchors.centerIn:parent
                id:layout
                Image { source:button.icon}
                Text { color:button.foregroundColor;
                    anchors.verticalCenter: parent.verticalCenter ;
                    text:button.text
                }
            }
        }
    }
}
