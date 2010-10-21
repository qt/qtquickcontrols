import Qt 4.7

Item {
    id:button

    width: 200
    height: 28

    property Component background : defaultbackground
    property alias text: input.text
    property string icon

    property color backgroundColor: "#fff";
    property color foregroundColor: "#222";

    // background
    Loader {
        id:backgroundComponent
        anchors.fill:parent
        sourceComponent:background
    }

    TextInput {
        id:input
        anchors.margins:4
        anchors.fill:backgroundComponent
        selectByMouse:true
    }


    // content
    Loader {
        id:labelComponent
        anchors.centerIn: parent
        sourceComponent:content
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
                source: "images/lineedit_normal.png"
                width: 80; height: 24
                border.left: 6; border.top: 6
                border.right: 6; border.bottom: 6
            }
        }
    }
}
