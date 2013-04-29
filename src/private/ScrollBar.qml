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
import QtQuick.Controls.Private 1.0

/*!
        \qmltype ScrollBar
        \internal
        \inqmlmodule QtQuick.Controls.Private 1.0
*/
Control {
    id: scrollbar

    property int orientation: Qt.Horizontal
    property alias minimumValue: slider.minimumValue
    property alias maximumValue: slider.maximumValue
    property alias value: slider.value

    activeFocusOnTab: false

    Accessible.role: Accessible.ScrollBar
    implicitWidth: __panel.implicitWidth
    implicitHeight: __panel.implicitHeight

    readonly property alias upPressed: internal.upPressed
    readonly property alias downPressed: internal.downPressed
    readonly property alias pageUpPressed: internal.pageUpPressed
    readonly property alias pageDownPressed: internal.pageDownPressed
    readonly property alias handlePressed: internal.handlePressed

    MouseArea {
        id: internal

        property bool upPressed
        property bool downPressed
        property bool pageUpPressed
        property bool pageDownPressed
        property bool handlePressed

        property bool horizontal: orientation === Qt.Horizontal
        property int pageStep: internal.horizontal ? width : height
        property int singleStep: 20
        property bool scrollToClickposition: internal.scrollToClickPosition

        anchors.fill: parent

        property bool autoincrement: false
        property bool scrollToClickPosition: __style ? __style.scrollToClickPosition : 0

        // Update hover item
        onEntered: if (!pressed) __panel.activeControl = __panel.hitTest(mouseX, mouseY)
        onExited: if (!pressed) __panel.activeControl = "none"
        onMouseXChanged: if (!pressed) __panel.activeControl = __panel.hitTest(mouseX, mouseY)
        hoverEnabled: true

        property var pressedX
        property var pressedY
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
            onTriggered: {
                if (upPressed && internal.containsMouse)
                    internal.decrement();
                else if (downPressed && internal.containsMouse)
                    internal.increment();
                else if (pageUpPressed)
                    internal.decrementPage();
                else if (pageDownPressed)
                    internal.incrementPage();
            }
        }

        onPositionChanged: {
            if (pressed && __panel.activeControl === "handle") {
                if (!horizontal)
                    slider.position = oldPosition + (mouseY - pressedY)
                else
                    slider.position = oldPosition + (mouseX - pressedX)
            }
        }

        onPressed: {
            __panel.activeControl = __panel.hitTest(mouseX, mouseY)
            scrollToClickposition = scrollToClickPosition
            var handleRect = __panel.subControlRect("handle")
            grooveSize =  horizontal ? __panel.subControlRect("groove").width -
                                       handleRect.width:
                                       __panel.subControlRect("groove").height -
                                       handleRect.height;
            if (__panel.activeControl === "handle") {
                pressedX = mouseX;
                pressedY = mouseY;
                internal.handlePressed = true;
                oldPosition = slider.position;
            } else if (__panel.activeControl === "up") {
                decrement();
                internal.upPressed = Qt.binding(function() {return containsMouse});
            } else if (__panel.activeControl === "down") {
                increment();
                internal.downPressed = Qt.binding(function() {return containsMouse});
            } else if (!scrollToClickposition){
                if (__panel.activeControl === "upPage") {
                    decrementPage();
                    internal.pageUpPressed = true;
                } else if (__panel.activeControl === "downPage") {
                    incrementPage();
                    internal.pageDownPressed = true;
                }
            } else {
                slider.position = horizontal ? mouseX -  handleRect.width/2
                                             : mouseY - handleRect.height/2
            }
        }

        onReleased: {
            __panel.activeControl = __panel.hitTest(mouseX, mouseY);
            autoincrement = false;
            internal.upPressed = false;
            internal.downPressed = false;
            internal.handlePressed = false;
            internal.pageUpPressed = false;
            internal.pageDownPressed = false;
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
