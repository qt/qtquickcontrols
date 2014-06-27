/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
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
import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles.Android 1.0
import "drawables"

DrawableLoader {
    id: delegate
    property bool active: false
    styleDef: styleData.hasSelection ? AndroidStyle.styleDef.textViewStyle.TextView_textSelectHandleRight
                                     : AndroidStyle.styleDef.textViewStyle.TextView_textSelectHandle
    x: styleData.hasSelection ? -width / 4 : -width / 2
    y: styleData.lineHeight
    opacity: 1.0

    pressed: styleData.pressed
    focused: control.activeFocus
    window_focused: focused && control.window && control.window.active

    Connections {
        target: editor
        ignoreUnknownSignals: true
        onDisplayTextChanged: {
            delegate.state = "hidden"
        }
    }

    Connections {
        target: styleData
        onActivated: {
            if (editor.text) {
                delegate.active = true
                delegate.opacity = 1.0
                delegate.state = ""
                if (!styleData.hasSelection)
                    delegate.state = "idle"
            }
        }
    }

    state: "hidden"

    states: [
        State {
            name: "hidden"
            when: editor.inputMethodComposing && !delegate.active && !editor.text
        },
        State {
            name: "idle"
            when: !styleData.hasSelection && !styleData.pressed
        }
    ]

    transitions: [
        Transition {
            to: "hidden"
            SequentialAnimation {
                PauseAnimation { duration: 100 }
                PropertyAction { target: delegate; property: "opacity"; value: 0.0 }
            }
        },
        Transition {
            to: "idle"
            SequentialAnimation {
                PauseAnimation { duration: 4000 }
                NumberAnimation { target: delegate; property: "opacity"; to: 0.0 }
                PropertyAction { target: delegate; property: "active"; value: false }
            }
        }
    ]
}
