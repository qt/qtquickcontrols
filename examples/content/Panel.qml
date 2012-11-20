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

Rectangle {
    id:root

    width: 540
    height: 340
    color:"#c3c3c3"
    ScrollArea {
        frame:false
        anchors.fill: parent

        Item {
            width:600
            height:600
            BorderImage {
                id: page
                source: "../images/page.png"
                y:10; x:50
                width: 400; height: 400
                border.left: 12; border.top: 12
                border.right: 12; border.bottom: 12
                Text {
                    id:text
                    anchors.fill: parent
                    anchors.margins: 40
                    text:textfield.text
                }
                Rectangle {
                    border.color: "#444"
                    anchors.centerIn: parent
                    color: Qt.rgba(s1.value, s2.value, s3.value)
                    width: 200
                    height: width
                }

            }

            BorderImage {
                id: sidebar
                source: "../images/panel.png"
                anchors.left: parent.left
                anchors.top: parent.top
                width: show ? 160 : 40
                height:parent.height
                Behavior on width { NumberAnimation { easing.type: Easing.OutSine ; duration: 250 } }
                property bool show: false
                border.left: 0;
                border.right: 26;
                MouseArea {
                    id:mouseArea
                    anchors.fill: parent
                    onClicked: sidebar.show = !sidebar.show
                }
                Column {
                    id: panel1
                    opacity: sidebar.show ? 1 : 0
                    Behavior on opacity { NumberAnimation { easing.type:Easing.InCubic; duration: 600} }

                    scale: sidebar.show ? 1 : 0
                    Behavior on scale { NumberAnimation { easing.type:Easing.InCubic; duration: 200 } }
                    transformOrigin: Item.Top

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 12
                    spacing:12

                    Button { width: parent.width - 12; text: "Close Panel"; onClicked: sidebar.show = false}
                    TextField { id: textfield; text: "Some text" ; width: parent.width - 12}
                    SpinBox { width: parent.width - 12}
                    CheckBox{ id: expander; text:"Sliders"}
                }

                Column {
                    id: panel2
                    opacity: expander.checked && sidebar.show ? 1 : 0
                    scale: opacity
                    Behavior on opacity{ NumberAnimation { easing.type:Easing.OutSine; duration: 300}}
                    transformOrigin: Item.Top
                    anchors.top: panel1.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 12
                    spacing: 12
                    Slider { id: s1; width:parent.width - 12; value:0.5}
                    Slider { id: s2; width:parent.width - 12; value:0.5}
                    Slider { id: s3; width:parent.width - 12; value:0.5}

                }
            }
        }
    }
}
