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

Components.SpinBox {
    id:spinbox

    property variant __upRect;
    property variant __downRect;
    property int __margin: (height -16)/2
    property string styleHint

    // Align height with button
    topMargin: __margin
    bottomMargin: __margin

    leftMargin:6
    rightMargin:6

    StyleItem {
        id:edititem
        elementType: "edit"
        visible: false
        contentWidth: 70
        contentHeight: 20
    }

    implicitWidth: edititem.implicitWidth
    implicitHeight: edititem.implicitHeight

    clip:false

    background: Item {
        anchors.fill: parent
        property variant __editRect

        Rectangle {
            id: editBackground
            x: __editRect.x - 1
            y: __editRect.y
            width: __editRect.width + 1
            height: __editRect.height
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
            __upRect = styleitem.subControlRect("up");
            __downRect = styleitem.subControlRect("down");
            __editRect = styleitem.subControlRect("edit");
            spinbox.leftMargin = __editRect.x + 2
            spinbox.rightMargin = spinbox.width -__editRect.width - __editRect.x
        }

        Component.onCompleted: updateRect()
        onWidthChanged: updateRect()
        onHeightChanged: updateRect()

        StyleItem {
            id: styleitem
            anchors.fill: parent
            elementType: "spinbox"
            sunken: (downEnabled && downPressed) | (upEnabled && upPressed)
            hover: containsMouse
            hasFocus: spinbox.focus
            enabled: spinbox.enabled
            value: (upPressed ? 1 : 0)           |
                   (downPressed == 1 ? 1<<1 : 0) |
                   (upEnabled ? (1<<2) : 0)      |
                   (downEnabled == 1 ? (1<<3) : 0)
            hint: spinbox.styleHint
        }
    }

    up: Item {
        x: __upRect.x
        y: __upRect.y
        width: __upRect.width
        height: __upRect.height
    }

    down: Item {
        x: __downRect.x
        y: __downRect.y
        width: __downRect.width
        height: __downRect.height
    }
}
