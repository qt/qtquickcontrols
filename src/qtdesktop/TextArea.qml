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

/*!
    \qmltype TextArea
    \inqmlmodule QtDesktop 1.0
    \brief TextArea is doing bla...bla...
*/

ScrollArea {
    id: area
    color: syspal.base
    width: 280
    height: 120
    contentWidth: edit.paintedWidth + (2 * documentMargins)

    property alias text: edit.text
    property alias wrapMode: edit.wrapMode
    property alias readOnly: edit.readOnly
    property bool tabChangesFocus: false
    property alias font: edit.font
    property alias activeFocusOnPress: edit.activeFocusOnPress
    property alias horizontalAlignment: edit.horizontalAlignment

    highlightOnFocus: true
    property int documentMargins: 4
    frame: true

    function append (string) {
        text += "\n" + string
        verticalScrollBar.value = verticalScrollBar.maximumValue
    }

    Accessible.role: Accessible.EditableText
    // FIXME: probably implement text interface
    Accessible.name: text

    TextEdit {
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.IBeamCursor
            acceptedButtons: Qt.NoButton
        }
        renderType: Text.NativeRendering

        id: edit
        selectionColor: syspal.highlight
        selectedTextColor: syspal.highlightedText
        wrapMode: TextEdit.WordWrap;
        width: area.viewportWidth - (2 * documentMargins)
        x: documentMargins
        y: documentMargins
        // height has to be big enough to handle mouse focus
        height: Math.max(area.height, paintedHeight)

        selectByMouse: true
        readOnly: false
        color: syspal.text

        SystemPalette {
            id: syspal
            colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
        }

        KeyNavigation.priority: KeyNavigation.BeforeItem
        KeyNavigation.tab: area.tabChangesFocus ? area.KeyNavigation.tab : null
        KeyNavigation.backtab: area.tabChangesFocus ? area.KeyNavigation.backtab : null

        onContentSizeChanged: {
            area.contentWidth = paintedWidth + (2 * documentMargins)
        }

        // keep textcursor within scrollarea
        onCursorPositionChanged: {
            if (cursorRectangle.y >= area.contentY + area.viewportHeight - 1.5*cursorRectangle.height - documentMargins)
                area.contentY = cursorRectangle.y - area.viewportHeight + 1.5*cursorRectangle.height + documentMargins
            else if (cursorRectangle.y < area.contentY)
                area.contentY = cursorRectangle.y

            if (cursorRectangle.x >= area.contentX + area.viewportWidth - documentMargins) {
                area.contentX = cursorRectangle.x - area.viewportWidth + documentMargins
            } else if (cursorRectangle.x < area.contentX)
                area.contentX = cursorRectangle.x
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_PageUp) {
            verticalValue = verticalValue - area.height
        } else if (event.key == Qt.Key_PageDown)
            verticalValue = verticalValue + area.height
    }
}
