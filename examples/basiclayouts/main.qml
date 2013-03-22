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





import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    title: "Basic layouts"
    property int margin: 11
    minimumWidth: mainLayout.implicitWidth + 2 * margin
    minimumHeight: mainLayout.implicitHeight + 2 * margin
    width: minimumWidth
    height: minimumHeight

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: margin
        spacing: 6
        GroupBox {
            id: rowBox
            title: "Row layout"

            Layout.fillWidth: true
            RowLayout {
                id: rowLayout
                spacing: 6
                Button {
                    text: "Button 1"
                }
                Button {
                    text: "Button 2"
                }
                Button {
                    text: "Button 3"
                }
                Button {
                    text: "Button 4"
                }
            }
        }

        GroupBox {
            id: gridBox
            title: "Grid layout"
            Layout.fillWidth: true
            GridLayout {
                id: gridLayout
                horizontalSpacing: 6
                verticalSpacing: 6
                Label {
                    text: "Line 1"
                    Layout.row: 0
                    Layout.column: 0
                }
                Label {
                    text: "Line 2"
                    Layout.row: 1
                    Layout.column: 0
                }
                Label {
                    text: "Line 3"
                    Layout.row: 2
                    Layout.column: 0
                }
                TextField {
                    Layout.row: 0
                    Layout.column: 1
                }
                TextField {
                    Layout.row: 1
                    Layout.column: 1
                }
                TextField {
                    Layout.row: 2
                    Layout.column: 1
                }
                TextArea {
                    text: "This widget spans over three rows in the grid layout"
                    Layout.row: 0
                    Layout.column: 2
                    Layout.rowSpan: 3
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
        TextField {
            id: t3
            placeholderText: "This is a placeholder for a TextField"
            width: 200
            height: 400
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
