/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2

Row {
    width: 200
    height: 50
    spacing: 10

    property var currentTextInput: textinput
    property alias tb: _tb
    property alias text1: textinput
    property alias text2: textinput2

    Action {
        id: bold
        text: "&Bold"
        onTriggered: currentTextInput.font.bold = !currentTextInput.font.bold
        checkable: true
        checked: currentTextInput.font.bold
    }
    ToolButton {
        id: _tb
        action: bold
    }

    TextInput {
        id: textinput
        text: "Hello"
        property bool isBold: font.bold
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: currentTextInput = textinput
        }
    }

    TextInput {
        id: textinput2
        text: "Hello2"
        property bool isBold: font.bold
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: currentTextInput = textinput2
        }
    }
}
