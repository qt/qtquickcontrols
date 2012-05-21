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
import "./behaviors"    // ButtonBehavior

Item {
    id: button

    signal clicked
    property alias pressed: behavior.pressed
    property alias containsMouse: behavior.containsMouse
    property alias checkable: behavior.checkable  // button toggles between checked and !checked
    property alias checked: behavior.checked
    property bool activeFocusOnPress: false

    property Component background: null
    property Item backgroundItem: backgroundLoader.item

    property color textColor: syspal.text;
    property string tooltip

    signal toolTipTriggered

    // implementation

    property string __position: "only"
    implicitWidth: backgroundLoader.item.width
    implicitHeight: backgroundLoader.item.height

    function animateClick() {
        behavior.pressed = true
        behavior.clicked()
        animateClickTimer.start()
    }

    Timer {
        id: animateClickTimer
        interval: 250
        onTriggered: behavior.pressed = false
    }

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: background
        property alias styledItem: button
        property alias position: button.__position
    }

    ButtonBehavior {
        id: behavior
        anchors.fill: parent
        onClicked: button.clicked()
        onPressedChanged: if (activeFocusOnPress) button.focus = true
        onMouseMoved: {tiptimer.restart()}
        Timer{
            id: tiptimer
            interval:1000
            running:containsMouse && tooltip.length
            onTriggered: button.toolTipTriggered()
        }
    }

    SystemPalette { id: syspal }
}
