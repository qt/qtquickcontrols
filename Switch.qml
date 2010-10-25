import Qt 4.7

Item {
    id:button

    width: Math.max(100, labelComponent.item.width + 2*10)
    height: Math.max(32, labelComponent.item.height + 2*4)

    signal clicked

    property alias hover: mousearea.containsMouse
    property bool pressed: false
    property bool checkable: true
    property bool checked: false

    property Component background : defaultbackground
    property Component content : defaultlabel

    property string text
    property string icon
    property int labelSpacing:8

    property color backgroundColor: checked ? "#cef" : "#fff"
    property color foregroundColor: "#333"

    property alias font: fontcontainer.font

    Text {id:fontcontainer; font.pixelSize:14} // Workaround since font is not a declarable type (bug?)

    // background
    Loader {
        id:backgroundComponent
        anchors.fill:parent
        sourceComponent:background
        opacity: enabled ? 1 : 0.8
    }

    // content
    Loader {
        id:labelComponent
        anchors.left: backgroundComponent.right
        anchors.leftMargin: labelSpacing
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent:content
    }

    MouseArea {
        id:mousearea
        enabled: button.enabled
        hoverEnabled: true
        anchors.fill: parent
        onMousePositionChanged:  {
            if (pressed ){
            }
        }

        onPressed: button.pressed = true
        onEntered: if(pressed && enabled) button.pressed = true  // handles clicks as well
        onExited: button.pressed = false
        onReleased: {
            if (button.pressed && enabled) { // No click if release outside area
                button.pressed  = false
                if (checkable)
                    checked = !checked;
                button.clicked()
            }
        }
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
                width: 80 ; height: 24
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
            }

            Text{
                anchors.right:parent.right
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.Center
                width: parent.width/2
                font.pixelSize: 14
                font.bold: true
                color:"#aaa"
                text:"OFF"
                style: "Sunken"
                styleColor: "white"
                opacity: checked ? 0 : (enabled ? 1 : 0.5)
                Behavior on opacity { NumberAnimation{ duration: 60}}
            }

            Text{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width/2
                horizontalAlignment: Text.Center
                font.pixelSize: 14
                font.bold: true
                color:"#aaa"
                text:"ON"
                style: "Sunken"
                styleColor: "white"
                opacity: checked ? (enabled ? 1 :0.5) : 0
                Behavior on opacity { NumberAnimation{ duration: 60}}
            }


            BorderImage {
                anchors.top:parent.top
                anchors.bottom: parent.bottom
                x: checked ? parent.width-width : 0
                width:parent.width/2
                id: buttonimage
                smooth:true
                source: pressed ? "images/switch_pressed.png" : "images/switch_normal.png"
                height: parent.height
                border.left: 4; border.top: 4
                border.right: 4; border.bottom: 4
                Behavior on x { NumberAnimation { duration: 60 ; easing.type:"InOutCirc"}
                }
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
                    opacity: (enabled ? 1 : 0.5)
                    font.pixelSize:14
                    text:button.text
                    y:4
                }
            }
        }
    }
}
