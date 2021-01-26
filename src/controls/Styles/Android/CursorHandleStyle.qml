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
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles.Android 1.0
import "drawables"

DrawableLoader {
    id: delegate

    property bool hasText: !!editor.text || !!editor.displayText

    styleDef: styleData.hasSelection ? AndroidStyle.styleDef.textViewStyle.TextView_textSelectHandleRight
                                     : AndroidStyle.styleDef.textViewStyle.TextView_textSelectHandle
    x: styleData.hasSelection ? -width / 4 : -width / 2
    y: styleData.lineHeight

    pressed: styleData.pressed
    focused: control.activeFocus
    window_focused: focused && control.Window.active

    opacity: hasText && (styleData.hasSelection || styleData.pressed || idle.running) ? 1.0 : 0.0
    visible: opacity > 0.0 && focused

    Timer {
        id: idle
        repeat: false
        interval: 4000
    }

    Connections {
        target: styleData
        function onActivated() { idle.restart() }
        function onPressedChanged() {
            if (!styleData.pressed)
                idle.restart()
        }
    }

    // Hide the cursor handle on textual changes, unless the signals are
    // indirectly triggered by activating/tapping/moving the handle. When
    // text prediction is enabled, the textual content may change when the
    // cursor moves and the predicted text is committed.
    Connections {
        target: editor
        ignoreUnknownSignals: true
        function onTextChanged() { if (!ignore.running) idle.stop() }
        function onDisplayTextChanged() { if (!ignore.running) idle.stop() }
        function onInputMethodComposing() { if (!ignore.running) idle.stop() }
    }

    Timer {
        id: ignore
        repeat: false
        interval: 250
        running: idle.running
    }
}
