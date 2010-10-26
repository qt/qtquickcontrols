import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: spinbox

    width: 200
    height: 32

    property real value: 0.0
    property real maximum: 99
    property real minimum: 0
    property real singlestep: 1

    property bool upEnabled: value != maximum;
    property bool downEnabled: value != minimum;

    property alias upPressed: mouseUp.pressed
    property alias downPressed: mouseDown.pressed
    property alias upHovered: mouseUp.containsMouse
    property alias downHovered: mouseDown.containsMouse
    property alias hover: mouseArea.containsMouse

    property color backgroundColor: "#fff";
    property color foregroundColor: "#222";

    property Component background: defaultStyle.background
    property Component content: defaultStyle.content
    property Component up: defaultStyle.up
    property Component down: defaultStyle.down
    DefaultStyles.SpinBoxStyle { id: defaultStyle }

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

    // background
    Loader {
        id: backgroundComponent
        anchors.fill: parent
        sourceComponent: background
    }

    // Content
    Loader {
        id: contentComponent
        anchors.fill: parent
        sourceComponent: content
        onLoaded: {
            item.parent = spinbox
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    TextInput {
        id: input
        font.pixelSize: 14
        anchors.margins: 5
        anchors.fill: contentComponent.item
        selectByMouse: true
        text: spinbox.value
        validator: DoubleValidator { bottom: 11; top: 31 }
        onTextChanged: { spinbox.setValue(text); }
        color: foregroundColor
        opacity: parent.enabled ? 1 : 0.5
    }

    Loader {
        id: upButton
        sourceComponent: up
        MouseArea {
            id: mouseUp
            anchors.fill: upButton.item
            onClicked: increment()
            Timer { running: parent.pressed; interval: 100 ; repeat: true ; onTriggered: increment() }
        }
        onLoaded: {
            item.parent = spinbox
            mouseUp.parent = item
            item.x = spinbox.width-item.width
            item.y = 0
        }
    }

    Loader {
        id: downButton
        sourceComponent: down
        MouseArea {
            id: mouseDown
            anchors.fill: downButton.item
            onClicked: decrement()
            Timer { running: parent.pressed; interval: 100 ; repeat: true ; onTriggered: decrement() }
        }
        onLoaded: {
            item.parent = spinbox
            mouseDown.parent = item
            item.x = spinbox.width-item.width
            item.y = spinbox.height - item.height
        }
    }
}
