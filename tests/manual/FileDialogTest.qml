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

Rectangle {

    width: 538
    height: 360

    ToolBar {
        id: toolbar
        width: parent.width
        height: 40
        Row {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter
            ToolButton{
                text: "Toggle"
                tooltip: "Toggle file dialog visible"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.visible = !fileDialogLoad.visible
            }
            ToolButton{
                text: "Open"
                tooltip: "Open the file dialog"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.open()
            }
            ToolButton{
                text: "Close"
                tooltip: "Close the file dialog"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.close()
            }
        }
    }

    FileDialog {
        id: fileDialogLoad
        folder: "/tmp"
        title: "Choose a file to open"
        selectMultiple: true
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]

        onAccepted: { console.log("Accepted: " + filePaths) }
    }

    Column {
        anchors.bottom: parent.bottom
        Text { text: "File dialog geometry " + fileDialogLoad.x + "," + fileDialogLoad.y + " " + fileDialogLoad.width + "x" + fileDialogLoad.height }
        Text { text: "File dialog visible? " + fileDialogLoad.visible }
    }
}

