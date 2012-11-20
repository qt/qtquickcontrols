/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
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

Row {
    anchors.fill: parent
    anchors.margins:16
    spacing:16

    Column {
        spacing:12

        GroupBox {
            title: "Animation options"
            adjustToContentSize: true
            ButtonRow {
                exclusive: false
                CheckBox {
                    id:fade
                    text: "Fade on hover"
                }
                CheckBox {
                    id: scale
                    text: "Scale on hover"
                }
            }
        }
        Row {
            spacing: 20
            Column {
                spacing: 10
                Button {
                    width:200
                    text: "Push button"
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                Slider {
                    value: 0.5
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                Slider {
                    id : slider1
                    value: 50
                    tickmarksEnabled: false
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                ProgressBar {
                    value: 0.5
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                ProgressBar {
                    indeterminate: true
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
            }
            Dial{
                width: 120
                height: 120
                scale: scale.checked && containsMouse ? 1.1 : 1
                opacity: !fade.checked || containsMouse ? 1 : 0.5
                Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
            }
        }
    }
}

