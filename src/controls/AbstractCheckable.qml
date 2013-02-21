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

/*!
    \qmltype AbstractCheckable
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup controls
    \brief An abstract representation of a checkable control
    \qmlabstract
*/

Control {
    id: abstractCheckable

    /*!
        Emitted whenever the radio button is clicked.
    */
    signal clicked

    /*!
        \qmlproperty bool RadioButton::pressed

        This property is \c true if the radio button is pressed.
        Set this property to manually invoke a mouse click.
    */
    readonly property alias pressed: mouseArea.effectivePressed

    /*!
        This property is \c true if the radio button is checked, and determines
        whether \l checkedState is \c Qt.Checked or \c Qt.UnChecked.

        If \l partiallyCheckedEnabled is \c true, this property will be
        \c false.
    */
    property bool checked: false

    /*!
        \qmlproperty bool RadioButton::containsMouse

        This property is \c true if the radio button currently contains the
        mouse cursor.
    */
    readonly property alias containsMouse: mouseArea.containsMouse

    /*!
        This property is \c true if the radio button takes the focus when it is
        pressed; \l{QQuickItem::forceActiveFocus()}{forceActiveFocus()} will be
        called on the radio button.
    */
    property bool activeFocusOnPress: false

    /*!
        \qmlproperty ExclusiveGroup RadioButton::exclusiveGroup

        This property stores the ExclusiveGroup that the radio button belongs
        to.
    */
    property ExclusiveGroup exclusiveGroup: null

    /*!
        This property holds the text that the label should display.
    */
    property string text

    /*! \internal */
    property var __cycleStatesHandler: cycleRadioButtonStates

    /*! \internal */
    onExclusiveGroupChanged: {
        if (exclusiveGroup)
            exclusiveGroup.bindCheckable(abstractCheckable)
    }

    MouseArea {
        id: mouseArea
        focus: true
        anchors.fill: parent
        hoverEnabled: true
        enabled: !keyPressed

        property bool keyPressed: false
        property bool effectivePressed: pressed && containsMouse || keyPressed

        onClicked: abstractCheckable.clicked();

        onPressed: if (activeFocusOnPress) forceActiveFocus();

        onReleased: {
            if (containsMouse && (!exclusiveGroup || !checked))
                __cycleStatesHandler();
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Space && !event.isAutoRepeat && !mouseArea.pressed)
            mouseArea.keyPressed = true;
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Space && !event.isAutoRepeat && mouseArea.keyPressed) {
            mouseArea.keyPressed = false;
            __cycleStatesHandler();
            clicked();
        }
    }
}
