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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "content"

Item {
    id: window
    width: 1024
    height: 400
    Row {
        id: row
        Text {
            text: "font size:"
        }
        SpinBox {
            value: 30
            onValueChanged: {
                if (textWithBaseLine) { // This might be emitted before the SpinBox is completed
                    textWithBaseLine.font.pixelSize = value
                    textWithBaseLineB.pixelSize = value
                    label.font.pixelSize = value
                }
            }
        }
        Text {
            text: "element height:"
        }
        SpinBox {
            value: 36
            onValueChanged: {
                if (textWithBaseLine) { // This might be emitted before the SpinBox is completed
                    textWithBaseLine.height = value
                    textWithBaseLineB.implicitHeight = value
                }
            }
        }
    }

    RectangleText {
        id: textWithBaseLine
        font.pixelSize: 30
        verticalAlignment: Text.AlignVCenter
        anchors.top: row.bottom
    }

    RectangleText {
        id: textWithBaseLine2
        font.pixelSize: 12
        anchors.left: textWithBaseLine.right
        anchors.baseline: textWithBaseLine.baseline
    }

    RectangleText {
        verticalAlignment: Text.AlignVCenter
        anchors.left: textWithBaseLine2.right
        anchors.baseline: textWithBaseLine.baseline
        height: 80
        baselineOffset: 20
    }


    Rectangle {
        x: 0
        y: textWithBaseLine.baselineOffset + textWithBaseLine.y
        height: 1
        width: parent.width
        opacity: 0.2
        color: "red"
    }

    ColumnLayout {
        height: Math.ceil(implicitHeight)
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Text {
            text: "Qt Quick Controls"
            Layout.fillWidth: true
        }
        RowLayout {
            Rectangle {
                color: "blue"
                implicitWidth: 1
                implicitHeight: 40
                Layout.fillHeight: true
                Rectangle {
                    y: textWithBaseLineC.y + textWithBaseLineC.baselineOffset
                    height: 1
                    width: window.width
                    opacity: 0.5
                    color: "red"
                }
                z: 1
            }
            RectangleText {
                id: textWithBaseLineC
                font.pixelSize: 20
                Layout.alignment: Qt.AlignBaseline
            }
            Label {
                id: label
                text: "Typography"
                Layout.alignment: Qt.AlignBaseline
            }
            Button {
                text: "Typography"
                Layout.alignment: Qt.AlignBaseline
            }
            CheckBox {
                text: "Typography"
                Layout.alignment: Qt.AlignBaseline
            }
            ComboBox {
                id: combo;
                model: ["Typography"]
                currentIndex: 0
                Layout.alignment: Qt.AlignBaseline
            }
            RadioButton {
                text: "Typography"
                Layout.alignment: Qt.AlignBaseline
            }
            SpinBox {
                value: 42
                Layout.alignment: Qt.AlignBaseline
            }
            TextField {
                text: "Typography"
                Layout.alignment: Qt.AlignBaseline
            }
            TextArea {
                text: "The quick brown fox jumps over the lazy dog"
                Layout.alignment: Qt.AlignBaseline
                implicitWidth: 100
                implicitHeight: 60
            }
        }

        Text {
            text: "Qml Elements"
            Layout.fillWidth: true
        }
        RowLayout {
            id: rowlayout
            Rectangle {
                color: "blue"
                implicitWidth: 1
                Layout.fillHeight: true
                Rectangle {
                    y: textWithBaseLineB.baselineOffset + textWithBaseLineB.y
                    height: 1
                    width: window.width
                    opacity: 0.2
                    color: "red"
                }
            }
            Item {
                id: textWithBaseLineB
                property alias pixelSize: txt2.font.pixelSize

                implicitWidth: txt2.implicitWidth
                implicitHeight: txt2.implicitHeight + 40
                // Note that we use 20 instead of txt2.y on the below line
                // This is because we cannot depend on a geometry (that the layout controls)
                // when we return size hints. size hints should never rely on the current arrangement
                baselineOffset: 20 + txt2.baselineOffset
                Rectangle {
                    anchors.fill: parent
                    color: "red"
                    opacity: 0.2
                }
                Text {
                    id: txt2
                    font.pixelSize: 30
                    opacity: 1.0
                    anchors.centerIn: parent
                    text: "Typography"
                }
                Layout.alignment: Qt.AlignBaseline
                Layout.fillWidth: true
            }

            RectangleText {
                font.pixelSize: 12
                Layout.alignment: Qt.AlignBaseline
                Layout.fillWidth: true
            }

            Item {
                implicitWidth: txt.implicitWidth
                implicitHeight: txt.implicitHeight + 40
                baselineOffset: txt.y + txt.baselineOffset
                Rectangle {
                    anchors.fill: parent
                    color: "red"
                    opacity: 0.2
                }
                Text {
                    id: txt
                    opacity: 1.0
                    anchors.centerIn: parent
                    text:"Typography"
                }
                Layout.alignment: Qt.AlignBaseline
                Layout.fillWidth: true
            }

            RectangleText {
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignBaseline
                baselineOffset: 60
                height: 80  // Needed for baselineOffset to be interpreted correctly
                Layout.preferredHeight: 80
                Layout.minimumHeight: Layout.preferredHeight
                Layout.fillWidth: true
            }
        }   // RowLayout
    }   // ColumnLayout
}
