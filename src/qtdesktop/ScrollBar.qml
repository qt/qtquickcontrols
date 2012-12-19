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
    \qmltype ScrollBar
    \inqmlmodule QtDesktop 1.0
    \brief ScrollBar is doing bla...bla...
*/

Item {
    id: scrollbar

    property int orientation: Qt.Horizontal
    property alias minimumValue: slider.minimumValue
    property alias maximumValue: slider.maximumValue
    property int pageStep: internal.horizontal ? width : height
    property int singleStep: 20
    property alias value: slider.value
    property bool scrollToClickposition: internal.scrollToClickPosition

    implicitWidth: loader.implicitWidth
    implicitHeight: loader.implicitHeight

    onValueChanged: internal.updateHandle()

    property Component style: Qt.createComponent(Settings.THEME_PATH + "/ScrollBarStyle.qml")

    property bool upPressed
    property bool downPressed

    property bool pageUpPressed
    property bool pageDownPressed

    MouseArea {
        id: internal

        property bool horizontal: orientation === Qt.Horizontal
        property alias styleItem: loader.item

        anchors.fill: parent

        property bool autoincrement: false
        property bool scrollToClickPosition: styleItem ? styleItem.scrollToClickPosition : 0
        property bool handlePressed

        // Update hover item
        onEntered: styleItem.activeControl = styleItem.hitTest(mouseX, mouseY)
        onExited: styleItem.activeControl = "none"
        onMouseXChanged: styleItem.activeControl = styleItem.hitTest(mouseX, mouseY)
        hoverEnabled: true

        property variant control
        property variant pressedX
        property variant pressedY
        property int oldPosition
        property int grooveSize

        Timer {
            running: upPressed || downPressed || pageUpPressed || pageDownPressed
            interval: 350
            onTriggered: internal.autoincrement = true
        }

        Timer {
            running: internal.autoincrement
            interval: 60
            repeat: true
            onTriggered: upPressed ? internal.decrement() : downPressed ? internal.increment() :
                                                            pageUpPressed ? internal.decrementPage() :
                                                                            internal.incrementPage()
        }

        onPositionChanged: {
            if (pressed && control === "handle") {
                //slider.positionAtMaximum = grooveSize
                if (!horizontal)
                    slider.position = oldPosition + (mouseY - pressedY)
                else
                    slider.position = oldPosition + (mouseX - pressedX)
            }
        }

        onPressed: {
            control = styleItem.hitTest(mouseX, mouseY)
            scrollToClickposition = scrollToClickPosition
            grooveSize =  horizontal ? styleItem.subControlRect("groove").width -
                                       styleItem.subControlRect("handle").width:
                                       styleItem.subControlRect("groove").height -
                                       styleItem.subControlRect("handle").height;
            if (control == "handle") {
                pressedX = mouseX
                pressedY = mouseY
                oldPosition = slider.position
            } else if (control == "up") {
                decrement();
                upPressed = true
            } else if (control == "down") {
                increment();
                downPressed = true
            } else if (!scrollToClickposition){
                if (control == "upPage") {
                    decrementPage();
                    pageUpPressed = true
                } else if (control == "downPage") {
                    incrementPage();
                    pageDownPressed = true
                }
            } else {
                slider.position = horizontal ? mouseX - handleRect.width/2
                                             : mouseY - handleRect.height/2
            }
        }

        onReleased: {
            autoincrement = false;
            upPressed = false;
            downPressed = false;
            pageUpPressed = false
            pageDownPressed = false
            control = ""
        }

        function incrementPage() {
            value += pageStep
            if (value > maximumValue)
                value = maximumValue
        }

        function decrementPage() {
            value -= pageStep
            if (value < minimumValue)
                value = minimumValue
        }

        function increment() {
            value += singleStep
            if (value > maximumValue)
                value = maximumValue
        }

        function decrement() {
            value -= singleStep
            if (value < minimumValue)
                value = minimumValue
        }

        Loader {
            id: loader
            property Item control: scrollbar
            sourceComponent: style
            anchors.fill: parent
        }

        property rect handleRect: Qt.rect(0,0,0,0)
        property rect grooveRect: Qt.rect(0,0,0,0)
        function updateHandle() {
            internal.handleRect = styleItem.subControlRect("handle")
            grooveRect = styleItem.subControlRect("groove");
        }

        RangeModel {
            id: slider
            minimumValue: 0.0
            maximumValue: 1.0
            value: 0
            stepSize: 0.0
            inverted: false
            positionAtMaximum: internal.grooveSize
        }
    }
}
