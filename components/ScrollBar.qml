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

import QtQuick 1.1
import "custom" as Components

Item {
    id: scrollbar

    property int orientation : Qt.Horizontal
    property alias minimumValue: slider.minimumValue
    property alias maximumValue: slider.maximumValue
    property int pageStep: styleitem.horizontal ? width : height
    property int singleStep: 20
    property alias value: slider.value
    property bool scrollToClickposition: styleitem.styleHint("scrollToClickPosition")

    implicitWidth: orientation == Qt.Horizontal ? 200 : internal.scrollbarExtent
    implicitHeight: orientation == Qt.Horizontal ? internal.scrollbarExtent : 200

    onValueChanged: internal.updateHandle()

    MouseArea {
        id: internal

        anchors.fill: parent
        property bool upPressed
        property bool downPressed
        property bool pageUpPressed
        property bool pageDownPressed

        property bool autoincrement: false
        property int scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
        property bool handlePressed

        // Update hover item
        onEntered: styleitem.activeControl = styleitem.hitTest(mouseX, mouseY)
        onExited: styleitem.activeControl = "none"
        onMouseXChanged: styleitem.activeControl = styleitem.hitTest(mouseX, mouseY)
        hoverEnabled: true

        property variant control
        property variant pressedX
        property variant pressedY
        property int oldPosition
        property int grooveSize

        Timer {
            running: internal.upPressed || internal.downPressed || internal.pageUpPressed || internal.pageDownPressed
            interval: 350
            onTriggered: internal.autoincrement = true
        }

        Timer {
            running: internal.autoincrement
            interval: 60
            repeat: true
            onTriggered: internal.upPressed ? internal.decrement() : internal.downPressed ? internal.increment() :
                                                                     internal.pageUpPressed ? internal.decrementPage() :
                                                                                              internal.incrementPage()
        }

        onMousePositionChanged: {
            if (pressed && control === "handle") {
                //slider.positionAtMaximum = grooveSize
                if (!styleitem.horizontal)
                    slider.position = oldPosition + (mouseY - pressedY)
                else
                    slider.position = oldPosition + (mouseX - pressedX)
            }
        }

        onPressed: {
            control = styleitem.hitTest(mouseX,mouseY)
            scrollToClickposition = styleitem.styleHint("scrollToClickPosition")
            grooveSize =  styleitem.horizontal? styleitem.subControlRect("groove").width -
                                                styleitem.subControlRect("handle").width:
                                                    styleitem.subControlRect("groove").height -
                                                    styleitem.subControlRect("handle").height;
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
                slider.position = styleitem.horizontal ? mouseX - handleRect.width/2
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

        StyleItem {
            id: styleitem
            anchors.fill:parent
            elementType: "scrollbar"
            hover: activeControl != "none"
            activeControl: "none"
            sunken: internal.upPressed | internal.downPressed
            minimum: slider.minimumValue
            maximum: slider.maximumValue
            value: slider.value
            horizontal: orientation == Qt.Horizontal
            enabled: parent.enabled
        }

        property variant handleRect: Qt.rect(0,0,0,0)
        property variant grooveRect: Qt.rect(0,0,0,0)
        function updateHandle() {
            internal.handleRect = styleitem.subControlRect("handle")
            grooveRect = styleitem.subControlRect("groove");
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
