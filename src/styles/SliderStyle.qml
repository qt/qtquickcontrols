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
    \qmltype SliderStyle
    \inqmlmodule QtDesktop.Styles 1.0
    \brief SliderStyle is doing bla...bla...
*/

Item {
    id: styleitem

    implicitWidth: 200
    implicitHeight: backgroundControl.item.implicitHeight

    property int leftMargin
    property int rightMargin

    property color backgroundColor: "lightgray"

    property Component handle: Rectangle {
        implicitWidth: 12
        implicitHeight: 14
        gradient: Gradient {
            GradientStop {color: backgroundColor ; position: 0}
            GradientStop {color: Qt.darker(backgroundColor, 1.2) ; position: 1}
        }
        antialiasing: true
        radius: height/2
        border.color: Qt.darker(backgroundColor, 1.8)
    }

    property Component background: Rectangle {
        implicitWidth: 12
        implicitHeight: 6
        gradient: Gradient {
            GradientStop {color: Qt.darker(backgroundColor, 1.2) ; position: 0}
            GradientStop {color: Qt.darker(backgroundColor, 1.5) ; position: 1}
        }
        antialiasing: true
        radius: height / 2.0
        border.color: Qt.darker(backgroundColor, 1.8)
    }

    Loader {
        id: backgroundControl
        sourceComponent: background
        width: parent.width
        anchors.fill: parent
    }

    Loader {
        sourceComponent: handle
        anchors.verticalCenter: backgroundControl.verticalCenter
        x: leftMargin + control.value / control.maximumValue * (parent.width - leftMargin - rightMargin - width)
    }
}
