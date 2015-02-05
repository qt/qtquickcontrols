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

Rectangle {
    width: 300
    height: 300
    id: rect

    Text {
        id: text
        text: "hello"
        anchors.centerIn: parent
    }

    Action {
        shortcut: "a"
        onTriggered: text.text = "a pressed"
    }
    Action { // ambiguous but disabled
        enabled: false
        shortcut: "a"
        onTriggered: text.text = "a (disabled) pressed"
    }

    Action { // ambiguous but disabled
        enabled: false
        shortcut: "b"
        onTriggered: text.text = "b (disabled) pressed"
    }
    Action {
        shortcut: "b"
        onTriggered: text.text = "b pressed"
    }

    Action {
        shortcut: "ctrl+c"
        onTriggered: text.text = "ctrl c pressed"
    }

    Action {
        shortcut: "d"
        onTriggered: text.text = "d pressed"
    }

    Action {
        shortcut: "alt+d"
        onTriggered: text.text = "alt d pressed"
    }

    Action {
        shortcut: "shift+d"
        onTriggered: text.text = "shift d pressed 1"
    }
    Action {
        shortcut: "shift+d"
        onTriggered: text.text = "shift d pressed 2"
    }

    Action {
        text: "&test"
        onTriggered: text.text = "alt t pressed"
    }

    CheckBox {
        text: "&checkbox"
        onClicked: text.text = "alt c pressed"
    }

    RadioButton {
        text: "&radiobutton"
        onClicked: text.text = "alt r pressed"
    }

    Button {
        text: "button&1"
        onClicked: text.text = "alt 1 pressed"
    }

    Button {
        action: Action {
            text: "button&2"
        }
        onClicked: text.text = "alt 2 pressed"
    }

    ToolButton {
        text: "toolbutton&3"
        onClicked: text.text = "alt 3 pressed"
    }

    ToolButton {
        action: Action {
            text: "toolbutton&4"
        }
        onClicked: text.text = "alt 4 pressed"
    }
}
