/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
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
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
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
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtDesktop 0.2

FocusScope {
    id: textfield
    property alias text: textInput.text
    property alias font: textInput.font

    property int minimumWidth: 0
    property int minimumHeight: 0

    property int inputHint // values tbd
    property bool acceptableInput: textInput.acceptableInput // read only
    property alias readOnly: textInput.readOnly // read only
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
    property alias activeFocusOnPress: textInput.activeFocusOnPress
    property alias containsMouse: mouseArea.containsMouse

    property Component delegate: StyleItem {
        anchors.fill: parent
        elementType: "edit"
        sunken: true
        hasFocus: textfield.activeFocus
        hover: containsMouse
        hint: textfield.styleHint
        contentWidth: 200
        contentHeight: 25

        Item {
            id: focusFrame
            anchors.fill: parent
            parent: textfield
            visible: framestyle.styleHint("focuswidget")
            StyleItem {
                id: framestyle
                anchors.margins: -2
                anchors.rightMargin:-4
                anchors.bottomMargin:-4
                anchors.fill: parent
                visible: textfield.activeFocus
                hint: textfield.styleHint
                elementType: "focusframe"
            }
        }
    }

    implicitWidth: loader.item.implicitWidth
    implicitHeight: loader.item.implicitHeight

    Accessible.name: text
    Accessible.role: Accessible.EditableText
    Accessible.description: placeholderText

    property string styleHint


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

    // Implementation

    SystemPalette {
        id: syspal
        colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    Loader {
        id: loader
        sourceComponent: delegate
        anchors.fill: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: textfield.forceActiveFocus()
    }

    onFocusChanged: {
        if (textfield.activeFocus)
            textInput.forceActiveFocus();
    }

    TextInput { // see QTBUG-14936
        id: textInput
        selectByMouse:true
        selectionColor: syspal.highlight
        selectedTextColor: syspal.highlightedText

        // Todo move these margins to StyleItem
        anchors.leftMargin: 4
        anchors.topMargin: 4
        anchors.rightMargin: 4
        anchors.bottomMargin: 4

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        color: syspal.text
        echoMode: passwordMode ? TextInput.Password : TextInput.Normal
        clip: true
    }

    Text {
        id: placeholderTextComponent
        anchors.fill: textInput
        font: textInput.font
        opacity: !textInput.text.length && !textInput.activeFocus ? 1 : 0
        color: "darkgray"
        text: "Enter text"
        clip: true
        elide: Text.ElideRight
        Behavior on opacity { NumberAnimation { duration: 90 } }
    }
}
