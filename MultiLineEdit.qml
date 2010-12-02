import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: multiLineEdit
    SystemPalette{id:syspal}

    property bool passwordMode: false

    property color textColor: syspal.text
    property color backgroundColor: syspal.base

    property Component background: defaultStyle.background
    property Component hints: defaultStyle.hints

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    clip:true

    width: Math.max(minimumWidth,
                    Math.max(textEdit.width, placeholderTextComponent.width) + leftMargin + rightMargin)

    height: Math.max(minimumHeight,
                     Math.max(textEdit.height, placeholderTextComponent.height) + topMargin + bottomMargin)

    property alias containsMouse: mouseArea.containsMouse
    property alias _hints: hintsLoader.item

    // Common API
    property int inputHint; // values tbd
    property alias text: textEdit.text
    property alias font: textEdit.font
    property bool readOnly:textEdit.readOnly // read only
    property alias placeholderText: placeholderTextComponent.text
    property alias selectedText: textEdit.selectedText
    property alias selectionEnd: textEdit.selectionEnd
    property alias selectionStart: textEdit.selectionStart
    property alias horizontalalignment: textEdit.horizontalAlignment
    property alias verticalAlignment: textEdit.verticalAlignment

    Loader { id: hintsLoader; sourceComponent: hints }
    Loader { sourceComponent: background; anchors.fill:parent}

    TextEdit{ // see QTBUG-14936
        id: textEdit
        font.pixelSize: _hints.fontPixelSize
        font.bold: _hints.fontBold

        anchors.leftMargin: leftMargin
        anchors.topMargin: topMargin
        anchors.rightMargin: rightMargin
        anchors.bottomMargin: bottomMargin

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        selectByMouse: true
        color: enabled ? textColor: Qt.tint(textColor, "#80ffffff")
        onActiveFocusChanged: cursorPosition = (!activeFocus ? 0 : text.length)
    }

    Text {
        id: placeholderTextComponent
        anchors.leftMargin: leftMargin
        anchors.topMargin: topMargin
        anchors.rightMargin: rightMargin
        anchors.bottomMargin: bottomMargin

        anchors.top:parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        font: textEdit.font
        opacity: !textEdit.text.length && !textEdit.activeFocus ? 1 : 0
        color: "gray"
        clip: true
        text: "Enter text"
        Behavior on opacity{NumberAnimation{duration:90}}
    }

    Text {
        id: unfocusedText
        clip: true
        anchors.fill: textEdit
        font: textEdit.font
        opacity: textEdit.text.length && !textEdit.activeFocus ? 1 : 0
        color: textEdit.color
        elide: Text.ElideRight
        text: textEdit.text
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: textEdit.focus = true   //mm Why did this stop working when textEdit was reparented to "content"?
    }
    DefaultStyles.LineEditStyle { id: defaultStyle }
}

