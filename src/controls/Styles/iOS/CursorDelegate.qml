/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

import QtQuick 2.2

Rectangle {
    id: cursor

    property Item input: parent

    width: 2
    height: input.cursorRectangle.height
    color: "#446cf2"
    antialiasing: false
    visible: input.activeFocus && input.selectionStart === input.selectionEnd
    state: "on"

    Connections {
        target: input
        function onCursorPositionChanged() {
            state = "on"
            timer.restart()
        }
    }

    Timer {
        id: timer
        running: cursor.visible && Qt.styleHints.cursorFlashTime >= 2
        repeat: true
        interval: Qt.styleHints.cursorFlashTime / 2
        onTriggered: cursor.state = cursor.state == "on" ? "off" : "on"
        onRunningChanged: {
            if (!running)
                cursor.state = "on"
        }
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: cursor; opacity: 1 }
        },
        State {
            name: "off"
            PropertyChanges { target: cursor; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "on"
            to: "off"
            NumberAnimation { property: "opacity"; duration: 150 }
        }
    ]
}

