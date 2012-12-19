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
    \qmltype GroupBox
    \inqmlmodule QtDesktop 1.0
    \brief GroupBox is doing bla...bla...
*/

Item {
    id: groupbox
    implicitWidth: Math.max(200, contentWidth + (loader.item ? loader.item.implicitWidth: 0) )
    implicitHeight: contentHeight + (loader.item ? loader.item.implicitHeight : 0) + 4

    default property alias data: content.data

    property string title
    property bool flat: false
    property bool checkable: false
    property int contentWidth: content.childrenRect.width
    property int contentHeight: content.childrenRect.height

    property Item checkbox: check
    property alias checked: check.checked
    property bool adjustToContentSize: false // Resizes groupbox to fit contents.
                                             // Note when using this, you cannot anchor children
    property Component style: Qt.createComponent(Settings.THEME_PATH + "/GroupBoxStyle.qml")

    Accessible.role: Accessible.Grouping
    Accessible.name: title

    Loader {
        id: loader
        property alias control: groupbox
        anchors.fill: parent
        property int topMargin: title.length > 0 || checkable ? 22 : 4
        property int bottomMargin: 4
        property int leftMargin: 4
        property int rightMargin: 4
        sourceComponent: style
        onLoaded: item.z = -1
    }

    CheckBox {
        id: check
        checked: true
        visible: checkable
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: loader.topMargin
    }

    Item {
        id:content
        z: 1
        focus: true
        anchors.topMargin: loader.topMargin
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        anchors.fill: parent
        enabled: (!checkable || checkbox.checked)
    }
}
