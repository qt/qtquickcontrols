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
import "Styles/Settings.js" as Settings

/*!
    \qmltype ProgressBar
    \inqmlmodule QtDesktop 1.0
    \brief ProgressBar is doing bla...bla...
*/

Item {
    id: progressbar

    property real value: 0
    property real minimumValue: 0
    property real maximumValue: 1
    property bool indeterminate: false
    property bool containsMouse: mouseArea.containsMouse

    property int minimumWidth: 0
    property int minimumHeight: 0

    property int orientation: Qt.Horizontal
    property Component style: Qt.createComponent(Settings.THEME_PATH + "/ProgressBarStyle.qml")
    property var styleHints:[]

    Accessible.role: Accessible.ProgressBar
    Accessible.name: value

    implicitWidth: orientation === Qt.Horizontal ? 200 : (loader.item ? loader.item.implicitHeight : 0)
    implicitHeight: orientation === Qt.Horizontal ? (loader.item ? loader.item.implicitHeight : 0) : 200

    Loader {
        id: loader
        property alias indeterminate: progressbar.indeterminate
        property alias value: progressbar.value
        property alias maximumValue: progressbar.maximumValue
        property alias minimumValue: progressbar.minimumValue

        property alias control: progressbar
        sourceComponent: style
        anchors.fill: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}

