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
import QtQuick.Controls.Styles 1.0

Style {
    id: styleRoot

    property Component frame: Rectangle {
        width: (parent ? parent.contentWidth : 0) + 2
        height: (parent ? parent.contentHeight : 0) + 2

        color: "lightgray"
        border { width: 1; color: "darkgray" }

        property int subMenuOverlap: -1
    }

    property Component menuItem: Rectangle {
        width: Math.max((parent ? parent.contentWidth : 0), text.paintedWidth + 12)
        height: isSeparator ? text.font.pixelSize / 2 : text.paintedHeight + 4
        color: selected ? "" : backgroundColor
        gradient: selected ? selectedGradient : undefined

        readonly property color backgroundColor: "lightgray"
        Gradient {
            id: selectedGradient
            GradientStop {color: Qt.lighter(backgroundColor, 1.8)  ; position: 0}
            GradientStop {color: backgroundColor ; position: 1.4}
        }
        antialiasing: true

        Text {
            id: text
            visible: !isSeparator
            text: menuItem.text + (hasSubmenu ? "  \u25b6" : "")
            x: 6
            anchors.verticalCenter: parent.verticalCenter
            renderType: Text.NativeRendering
            color: "black"
        }

        Rectangle {
            visible: isSeparator
            width: parent.width - 2
            height: 1
            x: 1
            anchors.verticalCenter: parent.verticalCenter
            color: "darkgray"
        }
    }
}
