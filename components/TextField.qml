import QtQuick 1.0
import "./styles/default" as DefaultStyles
import "./behaviors"    // TextEditMouseBehavior

// KNOWN ISSUES
// 1) TextField does not loose focus when !enabled if it is a FocusScope (see QTBUG-16161)

FocusScope {
    id: textField

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
    property alias echoMode: textInput.echoMode
    property alias cursorPosition: textInput.cursorPosition
    property alias inputMethodHints: textInput.inputMethodHints

    property color textColor: syspal.text
    property color backgroundColor: syspal.base
    property alias containsMouse: mouseEditBehavior.containsMouse

    property Component background: defaultStyle.background
    property Component hints: defaultStyle.hints

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    function copy() {
        textInput.copy()
    }

    function paste() {
        textInput.paste()
    }

    function cut() {
        textInput.cut()
    }

    function select(start, end) {
        textInput.select(start, end)
    }

    function selectAll() {
        textInput.selectAll()
    }

    function selectWord() {
        textInput.selectWord()
    }

    function positionAt(x) {
        var p = mapToItem(textInput, x, 0);
        return textInput.positionAt(p.x);
    }

    function positionToRectangle(pos) {
        var p = mapToItem(textInput, pos.x, pos.y);
        return textInput.positionToRectangle(p);
    }

    width: Math.max(minimumWidth,
                    textInput.width + leftMargin + rightMargin)

    height: Math.max(minimumHeight,
                     textInput.height + topMargin + bottomMargin)

    // Forward focus property
    property alias activeFocus: textInput.activeFocus

    // Implementation

    property alias desktopBehavior: mouseEditBehavior.desktopBehavior
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

        onActiveFocusChanged: {
            if (!desktopBehavior)
                state = (activeFocus ? "focused" : "")

            if (activeFocus)
                openSoftwareInputPanel()
            else
                closeSoftwareInputPanel()
        }

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


    TextEditMouseBehavior {
        id: mouseEditBehavior
        anchors.fill: parent
        textInput: textInput
        desktopBehavior: false
        copyPasteButtons: ButtonBlock {}
    }

    DefaultStyles.TextFieldStyle { id: defaultStyle }
}















