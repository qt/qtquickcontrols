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
import QtDesktop 1.0

FocusScope {
    id: spinbox

    property int minimumWidth: 0
    property int minimumHeight: 0

    property real value: 0.0
    property real maximumValue: 99
    property real minimumValue: 0
    property real singleStep: 1
    property string postfix

    property bool upEnabled: value != maximumValue;
    property bool downEnabled: value != minimumValue;
    property alias upPressed: mouseUp.pressed
    property alias downPressed: mouseDown.pressed
    property alias upHovered: mouseUp.containsMouse
    property alias downHovered: mouseDown.containsMouse
    property alias containsMouse: mouseArea.containsMouse
    property alias font: input.font
    property string styleHint

    Accessible.name: input.text
    Accessible.role: Accessible.SpinBox

    SystemPalette {
        id: syspal
        colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    property Component delegate: Item {
        property rect upRect
        property rect downRect
        property rect inputRect
        implicitHeight: styleitem.implicitHeight
        implicitWidth: styleitem.implicitWidth

        Rectangle {
            id: editBackground
            x: inputRect.x - 1
            y: inputRect.y
            width: inputRect.width + 1
            height: inputRect.height
            color: "white"
        }

        Item {
            id: focusFrame
            anchors.fill: editBackground
            visible: frameitem.styleHint("focuswidget")
            StyleItem {
                id: frameitem
                anchors.margins: -6
                anchors.leftMargin: -5
                anchors.rightMargin: -6
                anchors.fill: parent
                visible: spinbox.activeFocus
                elementType: "focusframe"
            }
        }

        function updateRect() {
            upRect = styleitem.subControlRect("up");
            downRect = styleitem.subControlRect("down");
            inputRect = styleitem.subControlRect("edit");
        }

        Component.onCompleted: updateRect()
        onWidthChanged: updateRect()
        onHeightChanged: updateRect()

        StyleItem {
            id: styleitem
            anchors.fill: parent
            elementType: "spinbox"
            contentWidth: 200
            contentHeight: 26
            sunken: (downEnabled && downPressed) | (upEnabled && upPressed)
            hover: containsMouse
            hasFocus: spinbox.focus
            enabled: spinbox.enabled
            value: (upPressed ? 1 : 0)           |
                   (downPressed == 1 ? 1<<1 : 0) |
                   (upEnabled ? (1<<2) : 0)      |
                   (downEnabled == 1 ? (1<<3) : 0)
            hint: spinbox.styleHint
            onFontChanged: input.font = font
        }
    }

    width: implicitWidth
    height: implicitHeight

    implicitWidth: loader.item ? loader.item.implicitWidth : 0
    implicitHeight: loader.item ? loader.item.implicitHeight : 0

    function increment() {
        setValue(input.text)
        value += singleStep
        if (value > maximumValue)
            value = maximumValue
        input.text = value
    }

    function decrement() {
        setValue(input.text)
        value -= singleStep
        if (value < minimumValue)
            value = minimumValue
        input.text = value
    }

    function setValue(v) {
        var newval = parseFloat(v)
        if (newval > maximumValue)
            newval = maximumValue
        else if (v < minimumValue)
            newval = minimumValue
        value = newval
        input.text = value
    }

    Component.onCompleted: setValue(value)

    onValueChanged: {
        input.valueUpdate = true
        input.text = value
        input.valueUpdate = false
    }

    Loader {
        id: loader
        property rect upRect: item ? item.upRect : Qt.rect(0, 0, 0, 0)
        property rect downRect: item ? item.downRect : Qt.rect(0, 0, 0, 0)
        property rect inputRect: item ? item.inputRect : Qt.rect(0, 0, 0, 0)
        sourceComponent: delegate
        anchors.fill: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    // Spinbox input field

    TextInput {
        id: input

        property bool valueUpdate: false

        clip: true

        renderType: Text.NativeRendering
        font: styleitem.font

        x: loader.inputRect.x
        y: loader.inputRect.y
        width: loader.inputRect.width
        anchors.verticalCenter: parent.verticalCenter

        selectByMouse: true
        selectionColor: syspal.highlight
        selectedTextColor: syspal.highlightedText

        // validator: DoubleValidator { bottom: minimumValue; top: maximumValue; }
        onAccepted: {setValue(input.text)}
        onActiveFocusChanged: setValue(input.text)
        color: syspal.text
        opacity: parent.enabled ? 1 : 0.5
        Text {
            text: postfix
            font: input.font
            anchors.rightMargin: 4
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Spinbox increment button

    MouseArea {
        id: mouseUp

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: loader.upRect.x
        anchors.topMargin: loader.upRect.y

        width: loader.upRect.width
        height: loader.upRect.height

        onClicked: increment()

        property bool autoincrement: false;
        onReleased: autoincrement = false
        Timer { running: mouseUp.pressed; interval: 350 ; onTriggered: mouseUp.autoincrement = true }
        Timer { running: mouseUp.autoincrement; interval: 60 ; repeat: true ; onTriggered: increment() }
    }

    // Spinbox decrement button

    MouseArea {
        id: mouseDown
        onClicked: decrement()

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: loader.downRect.x
        anchors.topMargin: loader.downRect.y

        width: loader.downRect.width
        height: loader.downRect.height

        property bool autoincrement: false;
        onReleased: autoincrement = false
        Timer { running: mouseDown.pressed; interval: 350 ; onTriggered: mouseDown.autoincrement = true }
        Timer { running: mouseDown.autoincrement; interval: 60 ; repeat: true ; onTriggered: decrement() }
    }

    Keys.onUpPressed: increment()
    Keys.onDownPressed: decrement()
}
