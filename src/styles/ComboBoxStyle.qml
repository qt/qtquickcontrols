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
import QtQuick.Controls.Styles 1.0

/*!
    \qmltype ComboBoxStyle
    \internal
    \inqmlmodule QtQuick.Controls.Styles 1.0
*/

Style {
    property color foregroundColor: __syspal.text

    property var __syspal: SystemPalette {
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    property Component panel: Item {
        implicitWidth: 100
        implicitHeight: 24
        property bool popup: false
        property alias font: textitem.font

        BorderImage {
            anchors.fill: parent
            source: control.__pressed ? "images/button_down.png" : "images/button.png"
            border.top: 6
            border.bottom: 6
            border.left: 6
            border.right: 6
            anchors.bottomMargin: -1
            BorderImage {
                anchors.fill: parent
                anchors.margins: -1
                anchors.topMargin: -2
                anchors.rightMargin: 0
                anchors.bottomMargin: 1
                source: "images/focusframe.png"
                visible: control.activeFocus
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
            }
            Text {
                id: textitem
                anchors.centerIn: parent
                text: control.currentText
                color: foregroundColor
                renderType: Text.NativeRendering
            }
            Image {
                source: "images/arrow-down.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 8
                opacity: 0.7
            }
        }
    }

    property Component dropDownStyle: MenuStyle { }

    property Component popupStyle: Style {

        property Component frame: Rectangle {
            width: (parent ? parent.contentWidth : 0)
            height: (parent ? parent.contentHeight : 0) + 2
            border.color: "#777"
        }

        property Component menuItem: Rectangle {
            implicitWidth: textItem.contentWidth
            implicitHeight: textItem.contentHeight
            border.color: "#777"
        }
    }
}
