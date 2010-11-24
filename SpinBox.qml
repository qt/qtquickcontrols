import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: spinbox

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: Math.max(minimumWidth,
                    input.width + leftMargin + rightMargin)

    height: Math.max(minimumHeight,
                     input.height + topMargin + bottomMargin)

    property real value: 0.0
    property real maximumValue: 99
    property real minimumValue: 0
    property real singlestep: 1

    property bool upEnabled: value != maximumValue;
    property bool downEnabled: value != minimumValue;

    property alias upPressed: mouseUp.pressed
    property alias downPressed: mouseDown.pressed
    property alias upHovered: mouseUp.containsMouse
    property alias downHovered: mouseDown.containsMouse
    property alias containsMouse: mouseArea.containsMouse

    property color backgroundColor: "#fff";
    property color textColor: "#222";

    property Component background: defaultStyle.background
    property Component up: defaultStyle.up
    property Component down: defaultStyle.down
    DefaultStyles.SpinBoxStyle { id: defaultStyle }

    function increment() {
        value += singlestep
        if (value > maximumValue)
            value = maximumValue
        input.text = value
    }

    function decrement() {
        value -= singlestep
        if (value < minimumValue)
            value = minimumValue
        input.text = value
    }

    function setValue(v) {
        var newval = parseFloat(v)
        if (newval > maximumValue)
            newval = maximumValue
        else if (value < minimumValue)
            newval = minimumValue
        value = newval
        input.text = value
    }

    // background
    Loader {
        id: backgroundComponent
        anchors.fill: parent
        sourceComponent: background
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
        anchors.leftMargin: leftMargin
        anchors.topMargin: topMargin
        anchors.rightMargin: rightMargin
        anchors.bottomMargin: bottomMargin
        anchors.fill: parent
        selectByMouse: true
        text: spinbox.value
        validator: DoubleValidator { bottom: 11; top: 31 }
        onTextChanged: { spinbox.setValue(text); }
        color: textColor
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
