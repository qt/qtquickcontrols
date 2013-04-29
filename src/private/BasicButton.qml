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
import QtQuick.Controls.Styles 1.0

/*!
    \qmltype BasicButton
    \internal
    \qmlabstract
    \inqmlmodule QtQuick.Controls.Private 1.0
*/

Control {
    id: button

    /*! This signal is emitted when the button is clicked. */
    signal clicked

    /*! \qmlproperty bool BasicButton::pressed

        This property holds whether the button is pressed. */
    readonly property bool pressed: behavior.effectivePressed

    /*! This property holds whether the button is checkable.

        The default value is \c false. */
    property bool checkable: false

    /*! This property holds whether the button is checked.

        Only checkable buttons can be checked.

        The default value is \c false. */
    property bool checked: false

    /*! This property holds the ExclusiveGroup that the button belongs to.

        The default value is \c null. */
    property ExclusiveGroup exclusiveGroup: null

    /*! This property holds the associated button action.

        If a button has an action associated, the action defines the
        button's properties like checked, text, tooltip etc.

        The default value is \c null. */
    property Action action: null

    /*! This property specifies whether the button should gain active focus when pressed.

        The default value is \c false. */
    property bool activeFocusOnPress: false

    /*! This property holds the button tooltip. */
    property string tooltip

    /*! \internal */
    property color __textColor: syspal.text
    /*! \internal */
    property string __position: "only"
    /*! \internal */
    property alias __containsMouse: behavior.containsMouse
    /*! \internal */
    property Action __action: action || ownAction

    /*! \internal */
    onExclusiveGroupChanged: {
        if (exclusiveGroup)
            exclusiveGroup.bindCheckable(button)
    }

    Accessible.role: Accessible.Button
    Accessible.description: tooltip

    /*! \internal */
    function accessiblePressAction() {
        __action.trigger()
    }

    Action { id: ownAction }

    Connections {
        target: __action
        onTriggered: button.clicked()
    }

    activeFocusOnTab: true

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
        onExited: Tooltip.hideText()
        onCanceled: Tooltip.hideText()
        onPressed: {
            if (activeFocusOnPress)
                button.forceActiveFocus()
            if (button.checkable)
                button.checked = !button.checked
        }

        Timer {
            interval: 1000
            running: behavior.containsMouse && !pressed && tooltip.length
            onTriggered: Tooltip.showText(behavior, Qt.point(behavior.mouseX, behavior.mouseY), tooltip)
        }
    }

    /*! \internal */
    property var __behavior: behavior

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
