/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
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

import QtQuick 2.0
import QtDesktop 1.0
import "Styles/Settings.js" as Settings

/*!
    \qmltype SpinBox
    \inqmlmodule QtDesktop 1.0
    \brief SpinBox is doing bla...bla...
*/

FocusScope {
    id: spinbox

    property int minimumWidth: 0
    property int minimumHeight: 0

    property real value: 0.0
    property real maximumValue: 99
    property real minimumValue: 0
    property real singleStep: 1
    property string postfix
    property var styleHints:[]

    property bool upEnabled: value != maximumValue;
    property bool downEnabled: value != minimumValue;
    property alias upPressed: mouseUp.pressed
    property alias downPressed: mouseDown.pressed
    property alias upHovered: mouseUp.containsMouse
    property alias downHovered: mouseDown.containsMouse
    property alias containsMouse: mouseArea.containsMouse
    property alias font: input.font
    property Component style: Qt.createComponent(Settings.THEME_PATH + "/SpinBoxStyle.qml")

    Accessible.name: input.text
    Accessible.role: Accessible.SpinBox

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
        property alias control: spinbox
        sourceComponent: style
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
        property Item styleItem: loader.item

        clip: true

        verticalAlignment: Qt.AlignVCenter
        anchors.fill: parent
        anchors.leftMargin: styleItem ? styleItem.leftMargin : 0
        anchors.topMargin: styleItem ? styleItem.topMargin : 0
        anchors.rightMargin: styleItem ? styleItem.rightMargin: 0
        anchors.bottomMargin: styleItem ? styleItem.bottomMargin: 0
        selectByMouse: true

        // validator: DoubleValidator { bottom: minimumValue; top: maximumValue; }
        onAccepted: {setValue(input.text)}
        onActiveFocusChanged: setValue(input.text)
        color: loader.item ? loader.item.foregroundColor : "black"
        selectionColor: loader.item ? loader.item.selectionColor : "black"
        selectedTextColor: loader.item ? loader.item.selectedTextColor : "black"

        opacity: parent.enabled ? 1 : 0.5
        renderType: Text.NativeRendering
        Text {
            text: postfix
            color: loader.item ? loader.item.foregroundColor : "black"
            anchors.rightMargin: 4
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Spinbox increment button

    MouseArea {
        id: mouseUp

        property var upRect: loader.item  ?  loader.item.upRect : null

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: upRect ? upRect.x : 0
        anchors.topMargin: upRect ? upRect.y : 0

        width: upRect ? upRect.width : 0
        height: upRect ? upRect.height : 0

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
        property var downRect: loader.item ? loader.item.downRect : null

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: downRect ? downRect.x : 0
        anchors.topMargin: downRect ? downRect.y : 0

        width: downRect ? downRect.width : 0
        height: downRect ? downRect.height : 0

        property bool autoincrement: false;
        onReleased: autoincrement = false
        Timer { running: mouseDown.pressed; interval: 350 ; onTriggered: mouseDown.autoincrement = true }
        Timer { running: mouseDown.autoincrement; interval: 60 ; repeat: true ; onTriggered: decrement() }
    }

    Keys.onUpPressed: increment()
    Keys.onDownPressed: decrement()
}
