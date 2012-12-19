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
import QtQuick.Window 2.0

/*!
    \qmltype Dialog
    \inqmlmodule QtDesktop 1.0
    \brief Dialog is doing bla...bla...
*/

Window {
    id: dialog

    width: 400
    height: 200

    signal closed
    signal accepted
    signal rejected
    signal buttonClicked

    property QtObject clickedButton: null

    property int noRole: 0
    property int acceptRole: 1
    property int rejectRole: 2
    property int helpRole: 3

    property int ok: 0x00000400
    property int cancel: 0x00400000
    property int close: 0x00200000
    property int help: 0x02000000

    property int buttons: ok | cancel

    modal: false

    default property alias data: content.data

    Item {
        id: content
        anchors.topMargin:16
        anchors.margins: 16
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: buttonrow.top
    }

    // Dialogs should center on parent
    onVisibleChanged: center()

    Row {
        property bool mac: (style.style == "mac")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 16
        anchors.topMargin:0
        anchors.bottomMargin: style.isMac ? 12 : 8
        spacing: 6

        Button {
            id: helpbutton
            property int role: helpRole
            visible: buttons & help
            text: "Help"
            focus: false
            Component.onCompleted: if (style.isMac) width = 22
            delegate: style.isMac ? machelpdelegate : cancelbutton.background
            onClicked: {
                clickedButton = helpbutton
                buttonClicked()
            }
            Component {
                id: machelpdelegate
                StyleItem {
                    anchors.fill: parent
                    elementType: "machelpbutton"
                    width: 22
                    height: 22
                    sunken: helpbutton.pressed
                    anchors.centerIn: parent
                }
            }
        }
    }
    Row {
        id: buttonrow
        spacing: 6
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        anchors.topMargin: 0
        anchors.bottomMargin: 8
        layoutDirection: style.isMac ? Qt.LeftToRight : Qt.RightToLeft

        Button {
            id: cancelbutton
            visible: buttons & cancel
            property int role: rejectRole
            text: "Cancel"
            onClicked: {
                visible: dialog.visible = false
                clickedButton = cancelbutton
                rejected()
                closed()
                buttonClicked(role)
            }
        }
        Button {
            id: okbutton
            property int role: acceptRole
            visible: buttons & ok
            text: "OK"
            defaultbutton: true
            onClicked: {
                visible: dialog.visible = false
                clickedButton = okbutton
                accepted()
                closed()
                buttonClicked()
            }
        }
    }
    StyleItem {
        id: style
        visible: false
        property bool isMac: (style.style == "mac")

    }
}
