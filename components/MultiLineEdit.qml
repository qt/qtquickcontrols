import QtQuick 1.0
import "./styles/default" as DefaultStyles
import "./behaviors"    // TextEditMouseBehavior

Item {
    id: multiLineEdit

    property alias text: textEdit.text
    property alias placeholderText: placeholderTextComponent.text
    property alias font: textEdit.font
    property bool passwordMode: false
    property bool readOnly: textEdit.readOnly // read only
    property int inputHint; // values tbd   (alias to TextEdit.inputMethodHints?
    property alias selectedText: textEdit.selectedText
    property alias selectionEnd: textEdit.selectionEnd
    property alias selectionStart: textEdit.selectionStart
    property alias horizontalAlignment: textEdit.horizontalAlignment
    property alias verticalAlignment: textEdit.verticalAlignment
    property alias wrapMode: textEdit.wrapMode  //mm Missing from spec

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

    width: Math.max(minimumWidth,
                    Math.max(textEdit.width, placeholderTextComponent.width) + leftMargin + rightMargin)
    height: Math.max(minimumHeight,
                     Math.max(textEdit.height, placeholderTextComponent.height) + topMargin + bottomMargin)


    // Implementation

    property alias desktopBehavior: mouseEditBehavior.desktopBehavior
    property alias _hints: hintsLoader.item
    clip: true

    SystemPalette { id: syspal }
    Loader { id: hintsLoader; sourceComponent: hints }
    Loader { sourceComponent: background; anchors.fill: parent }

    Flickable { //mm is FocusScope, so MultiLineEdit's root doesn't need to be, no?
        id: flickable
        clip: true

        anchors.fill: parent
        anchors.leftMargin: leftMargin
        anchors.topMargin: topMargin
        anchors.rightMargin: rightMargin
        anchors.bottomMargin: bottomMargin

        function ensureVisible(r) {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit { // see QTBUG-14936
            id: textEdit
            font.pixelSize: _hints.fontPixelSize
            font.bold: _hints.fontBold

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            color: enabled ? textColor: Qt.tint(textColor, "#80ffffff")
            wrapMode: desktopBehavior ? TextEdit.NoWrap : TextEdit.WordWrap
            onCursorRectangleChanged: flickable.ensureVisible(cursorRectangle)
        }
    }

    Text {
        id: placeholderTextComponent
        x: leftMargin; y: topMargin
        font: textEdit.font
        opacity: !textEdit.text.length && !textEdit.activeFocus ? 1 : 0
        color: "gray"
        clip: true
        text: "Enter text"
        Behavior on opacity { NumberAnimation { duration: 90 } }
    }


    TextEditMouseBehavior {
        id: mouseEditBehavior
        anchors.fill: parent
        textEdit: textEdit
        desktopBehavior: false
        copyPasteButtons: ButtonBlock {}
    }

    DefaultStyles.LineEditStyle { id: defaultStyle }
}

