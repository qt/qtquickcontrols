import Qt 4.7

Item {
    id:spinbox

    width: 200
    height: 32

    property Component background : defaultbackground
    property Component contents : defaultContents
    property Component up: defaultUp
    property Component down: defaultDown

    property bool upPressed : mouseup.pressed
    property bool downPressed : mousedown.pressed
    property bool upHovered: mouseup.containsMouse
    property bool downHovered: mousedown.containsMouse

    property alias hover : mousearea.containsMouse

    property bool upEnabled: value != maximum;
    property bool downEnabled: value != minimum;

    property real value : 0.0
    property real maximum: 99
    property real minimum: 0
    property real singlestep: 1

    property string prefix

    function increment() {
        value += singlestep
        if (value > maximum)
            value = maximum
        input.text = value
    }

    function decrement() {
        value -= singlestep
        if (value < minimum)
            value = minimum
        input.text = value
    }

    function setValue(v) {
        var newval = parseFloat(v)
        if (newval > maximum)
            newval = maximum
        else if (value < minimum)
            newval = minimum
        value = newval
        input.text = value
    }

    property string icon
    property color backgroundColor: "#fff";
    property color foregroundColor: "#222";

    // background
    Loader {
        id:backgroundComponent
        anchors.fill:parent
        sourceComponent:background
    }

    // Contents
    Loader {
        id:contentsComponent
        anchors.fill:parent
        sourceComponent:contents
        onLoaded: {
            item.parent = spinbox
        }
    }

    MouseArea {
        id:mousearea
        anchors.fill:parent
        hoverEnabled:true
    }

    TextInput {
        id:input
        font.pixelSize:14
        anchors.margins:5
        anchors.fill:contentsComponent.item
        selectByMouse:true
        text:spinbox.value
        validator:DoubleValidator{bottom: 11; top: 31}
        onTextChanged: { spinbox.setValue(text); }
        color:foregroundColor
        opacity:parent.enabled ? 1 : 0.5
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
                border.right: 50; border.bottom: 6
            }
        }
    }

    Loader {
        id:upButton
        sourceComponent:up
        MouseArea{
            id:mouseup
            anchors.fill:upButton.item
            onClicked: increment()
            Timer { running:parent.pressed ; interval:100 ; repeat:true ; onTriggered: increment() }
        }
        onLoaded: {
            item.parent = spinbox
            mouseup.parent = item
            item.x = spinbox.width-item.width
            item.y = 0
        }
    }

    Loader {
        id:downButton
        sourceComponent:down
        MouseArea {
            id:mousedown
            anchors.fill:downButton.item
            onClicked: decrement()
            Timer { running:parent.pressed ; interval:100 ; repeat:true ; onTriggered: decrement() }
        }
        onLoaded: {
            item.parent = spinbox
            mousedown.parent = item
            item.x = spinbox.width-item.width
            item.y = spinbox.height - item.height
        }
    }

    Component {
        id:defaultUp
        Item {
            anchors.right:parent.right
            anchors.top:parent.top
            width:24
            height:parent.height/2
            Image{
                anchors.left: parent.left;
                anchors.top:parent.top;
                anchors.topMargin:7
                opacity: (upEnabled && enabled) ? (upPressed ? 1 : 0.8) : 0.3
                source:"images/spinbox_up.png"
            }
        }
    }
    Component {
        id:defaultDown
        Item {
            anchors.right:parent.right
            anchors.bottom:parent.bottom
            width:24
            height:parent.height/2
            Image{
                anchors.left: parent.left;
                anchors.bottom:parent.bottom;
                anchors.bottomMargin:7
                opacity: (downEnabled && enabled) ? (downPressed ? 1 : 0.8) : 0.3
                source:"images/spinbox_down.png"
            }
        }
    }
    Component {
        id:defaultContents
        Item{
            anchors.fill:parent;
            anchors.leftMargin: 4;
            anchors.topMargin: 2;
            anchors.rightMargin: 24
        }
    }
}
