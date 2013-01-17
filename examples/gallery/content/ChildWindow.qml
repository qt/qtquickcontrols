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

Window {
    id: window1

    width: 400
    height: 400

    title: "child window"

    Rectangle {
        color: syspal.window
        anchors.fill: parent

        Text {
            id: dimensionsText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            text: {
                if (Desktop.screenCount == 1) {
                    "You have only a single screen.\nThe dimensions of your screen are: " + Desktop.screenWidth + " x " + Desktop.screenHeight;
                } else {
                    var text = "You have " + Desktop.screenCount + " screens.\nThe dimensions of your screens are: "
                    for(var i=0; i<Desktop.screenCount; i++) {
                        text += "\n" + Desktop.screenGeometry(i).width + " x " + Desktop.screenGeometry(i).height
                    }
                    return text;
                }
            }
        }

        Text {
            id: availableDimensionsText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dimensionsText.bottom
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            text: {
                var text = "The available dimensions of your screens are: "
                for(var i=0; i<Desktop.screenCount; i++) {
                    text += "\n" + Desktop.availableGeometry(i).width + " x " + Desktop.availableGeometry(i).height
                }
                return text;
            }
        }

        Text {
            id: closeText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: availableDimensionsText.bottom
            text: "This is a new Window, press the\nbutton below to close it again."
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: closeText.bottom
            id: closeWindowButton
            text:"Close"
            width: 98
            tooltip:"Press me, to close this window again"
            onClicked: window1.visible = false
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: closeWindowButton.bottom
            id: maximizeWindowButton
            text:"Maximize"
            width: 98
            tooltip:"Press me, to maximize this window again"
            onClicked: window1.windowState = Qt.WindowMaximized;
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: maximizeWindowButton.bottom
            id: normalizeWindowButton
            text:"Normalize"
            width: 98
            tooltip:"Press me, to normalize this window again"
            onClicked: window1.windowState = Qt.WindowNoState;
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: normalizeWindowButton.bottom
            id: minimizeWindowButton
            text:"Minimize"
            width: 98
            tooltip:"Press me, to minimize this window again"
            onClicked: window1.windowState = Qt.WindowMinimized;
        }
    }
}

