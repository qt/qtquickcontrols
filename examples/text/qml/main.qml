/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import org.qtproject.example 1.0

ApplicationWindow {
    width: 640
    height: 480
    minimumWidth: 400
    minimumHeight: 300

    title: document.documentTitle + " - Text Editor Example"

    Action {
        id: cut
        text: "Cut"
        shortcut: "ctrl+x"
        iconSource: "images/editcut.png"
        iconName: "edit-cut"
    }

    Action {
        id: copy
        text: "Copy"
        shortcut: "Ctrl+C"
        iconSource: "images/editcopy.png"
        iconName: "edit-copy"
        onTriggered: console.log("Ctrl C pressed - in action...")
    }

    Action {
        id: paste
        text: "Paste"
        shortcut: "ctrl+v"
        iconSource: "qrc:images/editpaste.png"
        iconName: "edit-paste"
    }

    Action {
        id: alignLeft
        text: "&Left"
        iconSource: "images/textleft.png"
        iconName: "format-justify-left"
        shortcut: "ctrl+l"
        onTriggered: document.alignment = Qt.AlignLeft
        checkable: true
        checked: document.alignment == Qt.AlignLeft
    }
    Action {
        id: alignCenter
        text: "C&enter"
        iconSource: "images/textcenter.png"
        iconName: "format-justify-center"
        onTriggered: document.alignment = Qt.AlignCenter
        checkable: true
        checked: document.alignment == Qt.AlignCenter
    }
    Action {
        id: alignRight
        text: "&Right"
        iconSource: "images/textright.png"
        iconName: "format-justify-right"
        onTriggered: document.alignment = Qt.AlignRight
        checkable: true
        checked: document.alignment == Qt.AlignRight
    }
    Action {
        id: alignJustify
        text: "&Justify"
        iconSource: "images/textjustify.png"
        iconName: "format-justify-fill"
        onTriggered: document.alignment = Qt.AlignJustify
        checkable: true
        checked: document.alignment == Qt.AlignJustify
    }

    Action {
        id: bold
        text: "&Bold"
        iconSource: "images/textbold.png"
        iconName: "format-text-bold"
        onTriggered: document.bold = !document.bold
        checkable: true
        checked: document.bold
    }
    Action {
        id: italic
        text: "&Italic"
        iconSource: "images/textitalic.png"
        iconName: "format-text-italic"
        onTriggered: document.italic = !document.italic
        checkable: true
        checked: document.italic
    }
    Action {
        id: underline
        text: "&Underline"
        iconSource: "images/textunder.png"
        iconName: "format-text-underline"
        onTriggered: document.underline = !document.underline
        checkable: true
        checked: document.underline
    }
    Action {
        id: color
        text: "&Color ..."
        iconSource: "images/textcolor.png"
        iconName: "format-text-color"
    }

    FileDialog {
        id: file
        nameFilters: ["Text files (*.txt)", "HTML files (*.html)"]
        onAccepted: document.fileUrl = fileUrl
    }

    Action {
        id: fileOpen
        iconSource: "images/fileopen.png"
        iconName: "document-open"
        text: "Open"
        onTriggered: file.open()
    }

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { action: fileOpen }
            MenuItem { text: "Quit"; onTriggered: Qt.quit() }
        }
        Menu {
            title: "&Edit"
            MenuItem { action: copy }
            MenuItem { action: cut }
            MenuItem { action: paste }
        }
        Menu {
            title: "F&ormat"
            MenuItem { action: bold }
            MenuItem { action: italic }
            MenuItem { action: underline }
            MenuSeparator {}
            MenuItem { action: alignLeft }
            MenuItem { action: alignCenter }
            MenuItem { action: alignRight }
            MenuItem { action: alignJustify }
            MenuSeparator {}
            MenuItem { action: color }
        }
        Menu {
            title: "&Help"
            MenuItem { text: "About..." }
            MenuItem { text: "About Qt" }
        }
    }

    toolBar: ToolBar {
        id: mainToolBar
        width: parent.width
        RowLayout {
            anchors.fill: parent
            spacing: 1
            ToolButton { action: fileOpen }

            Item { width: 4 }
            ToolButton { action: copy }
            ToolButton { action: cut }
            ToolButton { action: paste }
            Item { width: 4 }
            ToolButton { action: bold }
            ToolButton { action: italic }
            ToolButton { action: underline }

            Item { width: 4 }
            ToolButton { action: alignLeft }
            ToolButton { action: alignCenter }
            ToolButton { action: alignRight }
            ToolButton { action: alignJustify }
            Item { Layout.fillWidth: true }
        }
    }
    ToolBar {
        id: secondaryToolBar
        width: parent.width

        RowLayout {
            anchors.fill: parent
            anchors.margins: 4
            ComboBox {
                model: document.defaultFontSizes
                onCurrentTextChanged: document.fontSize = currentText
                currentIndex: document.defaultFontSizes.indexOf(document.fontSize + "")
            }
            TextField { id: fontEdit; enabled: false }
            Item { Layout.fillWidth: true }
        }
    }

    TextArea {
        Accessible.name: "document"
        id: textArea
        width: parent.width
        anchors.top: secondaryToolBar.bottom
        anchors.bottom: parent.bottom
        text: document.text
        textFormat: Qt.RichText
        Component.onCompleted: forceActiveFocus()
    }

    DocumentHandler {
        id: document
        target: textArea
        cursorPosition: textArea.cursorPosition
        selectionStart: textArea.selectionStart
        selectionEnd: textArea.selectionEnd
        onCurrentFontChanged: {
            fontEdit.text = currentFont.family
        }
    }
}
