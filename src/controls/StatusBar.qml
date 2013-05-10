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
import QtQuick.Controls.Private 1.0

/*!
    \qmltype StatusBar
    \inqmlmodule QtQuick.Controls 1.0
    \since QtQuick.Controls 1.0
    \ingroup applicationwindow
    \brief Contains status information in your app.

    The common way of using StatusBar is in relation to \l ApplicationWindow.

    Note that the StatusBar does not provide a layout of its own, but requires
    you to position its contents, for instance by creating a \l Row.

    \code
    ApplicationWindow {
        statusBar: StatusBar {
            Label {
                text: "Read Only"
                anchors.centerIn: parent
            }
        }
    }
    \endcode
*/

Item {
    id: statusbar
    activeFocusOnTab: false
    Accessible.role: Accessible.StatusBar
    width: parent ? parent.width : implicitWidth
    implicitWidth: loader.item.implicitHeight
    implicitHeight: loader.item ? loader.item.implicitHeight : 0
    property Component style: Qt.createComponent(Settings.theme() + "/StatusBarStyle.qml", statusbar)
    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: style
        property var __control: statusbar
    }
}
