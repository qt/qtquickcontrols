import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: lineEdit

    property alias text: textInput.text
    property alias userPrompt: userPromptText.text
    property bool passwordMode: false

    property color textColor: _hints.textColor
    property color backgroundColor: _hints.backgroundColor
    property alias font: textInput.font

    property Component background: defaultStyle.background
    property Component hints: defaultStyle.hints

    property int preferredWidth: defaultStyle.preferredWidth
    property int preferredHeight: defaultStyle.preferredHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: Math.max(preferredWidth,
                    textInput.width + leftMargin + rightMargin)

    height: Math.max(preferredHeight,
                     textInput.height + topMargin + bottomMargin)

    property alias containsMouse: mouseArea.containsMouse
    property alias _hints: hintsLoader.item

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

        //            focus: true
        selectByMouse: true
        color: enabled ? textColor: Qt.tint(textColor, "#80ffffff")
        onActiveFocusChanged: cursorPosition = (!activeFocus ? 0 : text.length)


        //mm Focus handling seems broken
        echoMode: passwordMode ? _hints.passwordEchoMode : (activeFocus?TextInput.Normal:TextInput.NoEcho)
        //            activeFocusOnPress: false // should be handled by mouseArea

        //            MouseArea {
        //                anchors.fill: parent
        //                onPressed: textInput.focus = true
        //            }
    }

    Text {
        id: userPromptText
        anchors.fill: textInput
        font: textInput.font
        opacity: !textInput.text.length && !textInput.activeFocus ? 1 : 0
        color: "gray"
        clip: true
        text: "Enter text"
    }

    Text {
        id: unfocusedText
        clip: true
        anchors.fill: textInput
        font: textInput.font
        opacity: !passwordMode && textInput.text.length && !textInput.activeFocus ? 1 : 0
        color: textInput.color
        elide: Text.ElideRight
        text: textInput.text
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: textInput.focus = true   //mm Why did this stop working when TextInput was reparented to "content"?
    }
    DefaultStyles.LineEditStyle { id: defaultStyle }
}

