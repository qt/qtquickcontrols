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

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.0

/*!
        \qmltype BasicButton
        \internal
        \qmlabstract
        \inqmlmodule QtQuick.Controls.Private 1.0
*/

Control {
    id: button

    signal clicked
    property alias pressed: behavior.effectivePressed
    property bool checkable: false
    property bool checked: false
    property ExclusiveGroup exclusiveGroup: null

    property Action action: null

    onExclusiveGroupChanged: {
        if (exclusiveGroup)
            exclusiveGroup.bindCheckable(button)
    }

    property bool activeFocusOnPress: false

    property color textColor: syspal.text
    property string tooltip

    Accessible.role: Accessible.Button
    Accessible.description: tooltip

    signal tooltipTriggered

    // implementation
    property string __position: "only"
    /*! \internal */
    property alias __containsMouse: behavior.containsMouse

    Action { id: ownAction; onTriggered: console.log("triggered", ownAction.text) }
    /*! \internal */
    property Action __action: action || ownAction

    Connections {
        target: __action
        onTriggered: button.clicked()
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Space && !event.isAutoRepeat && !behavior.pressed)
            behavior.keyPressed = true;
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Space && !event.isAutoRepeat && behavior.keyPressed) {
            behavior.keyPressed = false;
            __action.trigger()
        }
    }

    MouseArea {
        id: behavior
        property bool checkable: __action.checkable
        property bool checked: __action.checked
        property bool keyPressed: false
        property bool effectivePressed: pressed && containsMouse || keyPressed

        anchors.fill: parent
        hoverEnabled: true
        enabled: !keyPressed

        onReleased: if (containsMouse) __action.trigger()
        onExited: PrivateHelper.hideTooltip()
        onCanceled: PrivateHelper.hideTooltip()
        onPressed: if (activeFocusOnPress) button.forceActiveFocus()

        Timer {
            interval: 1000
            running: behavior.containsMouse && !pressed && tooltip.length
            onTriggered: PrivateHelper.showTooltip(behavior, Qt.point(behavior.mouseX, behavior.mouseY), tooltip)
        }
    }

    SystemPalette { id: syspal }

    states: [
        State {
            name: "ownAction"
            when: action === null
            PropertyChanges {
                target: ownAction
                enabled: button.enabled
                checkable: button.checkable
                checked: button.checked
                exclusiveGroup: button.exclusiveGroup
                text: button.text
                iconSource: button.iconSource
                tooltip: button.tooltip
            }
        },

        State {
            name: "boundAction"
            when: action !== null
            PropertyChanges {
                target: button
                enabled: action.enabled
                checkable: action.checkable
                checked: action.checked
                exclusiveGroup: action.exclusiveGroup
                text: action.text
                iconSource: action.iconSource
                tooltip: action.tooltip
            }
        }
    ]
}
