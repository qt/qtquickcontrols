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

/*!
    \qmltype ScrollBarStyle
    \inqmlmodule QtDesktop.Styles 1.0
    \brief ScrollBarStyle is doing bla...bla...
*/

Rectangle {
    id: styleitem

    readonly property bool horizontal: control.orientation === Qt.Horizontal

    implicitWidth: horizontal ? 200 : bg.implicitWidth
    implicitHeight: horizontal ? bg.implicitHeight : 200

    property Component background: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        color: "gray"
    }

    property Component handle: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        color: "lightgray"
        border.color: "#aaa"
    }

    property Component incrementControl: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        gradient: Gradient {
            GradientStop {color: control.downPressed ? "lightgray" : "white" ; position: 0}
            GradientStop {color: control.downPressed ? "lightgray" : "lightgray" ; position: 1}
        }
        border.color: "#aaa"
    }

    property Component decrementControl: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        color: "lightgray"
        gradient: Gradient {
            GradientStop {color: control.upPressed ? "lightgray" : "white" ; position: 0}
            GradientStop {color: control.upPressed ? "lightgray" : "lightgray" ; position: 1}
        }
        border.color: "#aaa"
    }

    property bool scrollToClickPosition: true
    property int minimumHandleLength: 30
    property int handleOverlap: 1

    property string activeControl: ""
    function pixelMetric(arg) {
        if (arg === "scrollbarExtent")
            return (styleitem.horizontal ? bg.height : bg.width);
        return 0;
    }

    function styleHint(arg) {
        return false;
    }

    function hitTest(argX, argY) {
        if (itemIsHit(handleControl, argX, argY))
            return "handle"
        else if (itemIsHit(upControl, argX, argY))
            return "up";
        else if (itemIsHit(downControl, argX, argY))
            return "down";
        else if (itemIsHit(bg, argX, argY)) {
            if (styleitem.horizontal && argX < handleControl.x || !styleitem.horizontal && argY < handleControl.y)
                return "upPage"
            else
                return "downPage"
        }

        return "none";
    }

    function subControlRect(arg) {
        if (arg === "handle") {
            return Qt.rect(handleControl.x, handleControl.y, handleControl.width, handleControl.height);
        } else if (arg === "groove") {
            if (styleitem.horizontal) {
                return Qt.rect(upControl.width - styleitem.handleOverlap,
                               0,
                               control.width - (upControl.width + downControl.width - styleitem.handleOverlap * 2),
                               control.height);
            } else {
                return Qt.rect(0,
                               upControl.height - styleitem.handleOverlap,
                               control.width,
                               control.height - (upControl.height + downControl.height - styleitem.handleOverlap * 2));
            }
        }
        return Qt.rect(0,0,0,0);
    }

    function itemIsHit(argItem, argX, argY) {
        var pos = argItem.mapFromItem(control, argX, argY);
        return (pos.x >= 0 && pos.x <= argItem.width && pos.y >= 0 && pos.y <= argItem.height);
    }

    Loader {
        id: upControl
        anchors.top: parent.top
        anchors.left: parent.left
        sourceComponent: decrementControl
        property bool mouseOver: activeControl === "up"
        property bool pressed: control.upPressed
    }

    Loader {
        id: bg
        width: parent.width
        anchors.top: horizontal ? undefined : upControl.bottom
        anchors.bottom: horizontal ? undefined : downControl.top
        anchors.left:  horizontal ? upControl.right : undefined
        anchors.right: horizontal ? downControl.left : undefined
        sourceComponent: background
    }

    Loader {
        id: downControl
        anchors.bottom: horizontal ? undefined : parent.bottom
        anchors.right: horizontal ? parent.right : undefined
        sourceComponent: incrementControl
        property bool mouseOver: activeControl === "down"
        property bool pressed: control.downPressed
    }

    Loader{
        id: handleControl
        property int totalextent: horizontal ? bg.width : bg.height
        property int extent: Math.max(minimumHandleLength, totalextent - control.maximumValue + 2 * handleOverlap)
        property bool mouseOver: activeControl === "handle"

        height: horizontal ? implicitHeight : extent
        width: horizontal ? extent : implicitWidth
        anchors.top: bg.top
        anchors.left: bg.left
        anchors.topMargin: horizontal ? 0 : -handleOverlap + (control.value / control.maximumValue) * (bg.height + 2 * handleOverlap- height)
        anchors.leftMargin: horizontal ? -handleOverlap + (control.value / control.maximumValue) * (bg.width + 2 * handleOverlap - width) : 0
        sourceComponent: handle
    }
}
