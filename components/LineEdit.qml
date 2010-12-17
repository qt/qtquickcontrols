import QtQuick 1.0
import "./styles/default" as DefaultStyles

// KNOWN ISSUES
// 1) LineEdit does not loose focus when !enabled if it is a FocusScope (see QTBUG-16161)

Item {  //mm Does this need to be a FocusScope or not?  //needs to be a FocusScope as long as TextInput is not in e.g. a Flickable's scope
    id: lineEdit

    property alias text: textInput.text
    property alias font: textInput.font

    property int inputHint // values tbd
    property bool acceptableInput: textInput.acceptableInput // read only
    property bool readOnly: textInput.readOnly // read only
    property alias placeholderText: placeholderTextComponent.text
    property bool  passwordMode: false
    property alias selectedText: textInput.selectedText
    property alias selectionEnd: textInput.selectionEnd
    property alias selectionStart: textInput.selectionStart
    property alias validator: textInput.validator
    property alias inputMask: textInput.inputMask
    property alias horizontalalignment: textInput.horizontalAlignment

    property color textColor: syspal.text
    property color backgroundColor: syspal.base
    property alias containsMouse: mouseArea.containsMouse

    property Component background: defaultStyle.background
    property Component hints: defaultStyle.hints

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: Math.max(minimumWidth,
                    textInput.width + leftMargin + rightMargin)

    height: Math.max(minimumHeight,
                     textInput.height + topMargin + bottomMargin)


    // Implementation

    property bool desktopBehavior: true    //mm Need styling hint
    property alias _hints: hintsLoader.item
    clip: true

    SystemPalette { id: syspal }
    Loader { id: hintsLoader; sourceComponent: hints }
    Loader { sourceComponent: background; anchors.fill:parent}

    TextInput { // see QTBUG-14936
        id: textInput
        font.pixelSize: _hints.fontPixelSize
        font.bold: _hints.fontBold

        anchors.leftMargin: leftMargin
        anchors.topMargin: topMargin
        anchors.rightMargin: rightMargin
        anchors.bottomMargin: bottomMargin

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        opacity: desktopBehavior || activeFocus ? 1 : 0
        color: enabled ? textColor : Qt.tint(textColor, "#80ffffff")
        echoMode: passwordMode ? _hints.passwordEchoMode : TextInput.Normal

        selectByMouse: false    // textSelection is handled explicitly by mouseArea below
        focus: true             // needed when focus is set on the LineEdit instance "from the outside"
        activeFocusOnPress: false // explicitly handled my mouseArea below
        onActiveFocusChanged: if(!desktopBehavior) state = (activeFocus ? "focused" : "")

        states: [
            State {
                name: ""
                PropertyChanges { target: textInput; cursorPosition: 0 }
            },
            State {
                name: "focused"
                PropertyChanges { target: textInput; cursorPosition: textInput.text.length }
            }
        ]

        transitions: Transition {
            to: "focused"
            SequentialAnimation {
                ScriptAction { script: textInput.cursorVisible = false; }
                ScriptAction { script: textInput.cursorPosition = textInput.positionAt(textInput.width); }
                NumberAnimation { target: textInput; property: "cursorPosition"; duration: 150 }
                ScriptAction { script: textInput.cursorVisible = true; }
            }
        }
    }

    Text {
        id: placeholderTextComponent
        anchors.fill: textInput
        font: textInput.font
        opacity: !textInput.text.length && !textInput.activeFocus ? 1 : 0
        color: "gray"
        text: "Enter text"
        Behavior on opacity { NumberAnimation { duration: 90 } }
    }

    Text {
        id: unfocusedText
        clip: true
        anchors.fill: textInput
        font: textInput.font
        opacity: !desktopBehavior && !passwordMode && textInput.text.length && !textInput.activeFocus ? 1 : 0
        color: textInput.color
        elide: Text.ElideRight
        text: textInput.text
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        drag.target: Item {} // work-around for Flickable stealing the mouse, which is expected (?), see QTBUG-15231

        property int pressedPos

        //mm see QTBUG-15814
        onPressed: {
            textInput.forceActiveFocus();    //mm see QTBUG-16157
            textInput.cursorPosition = textInput.positionAt(mouse.x-textInput.x);
            if(desktopBehavior) {
                pressedPos = textInput.cursorPosition;
            }
        }
        onPositionChanged: {
            if(!pressed)
                return;

            if(desktopBehavior) {
                textInput.select(pressedPos, textInput.positionAt(mouse.x-textInput.x));
            } else {
                textInput.cursorPosition = textInput.positionAt(mouse.x-textInput.x);
            }
        }

        onDoubleClicked: {
            if(desktopBehavior) {
                textInput.selectWord(textInput.positionAt(mouse.x-textInput.x));
            }
        }

//        onTrippleClicked: if(desktopBehavior) textInput.selectAll();
    }


    DefaultStyles.LineEditStyle { id: defaultStyle }
}

