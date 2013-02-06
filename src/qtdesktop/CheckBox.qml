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
import QtDesktop.Private 1.0

/*!
    \qmltype CheckBox
    \inqmlmodule QtDesktop 1.0
    \ingroup controls
    \brief A checkbox with a text label

    A CheckBox is an option button that can be toggled on (checked) or off
    (unchecked). Checkboxes are typically used to represent features in an
    application that can be enabled or disabled without affecting others.

    The state of the checkbox can be set with the \l checked property.

    The text of the label shown next to the checkbox can be set with the \l text
    property.

    Whenever a CheckBox is clicked, it emits the clicked() signal.
*/

FocusScope {
    id: checkBox

    /*!
        Emitted whenever the checkbox is clicked.
    */
    signal clicked

    /*!
        \qmlproperty bool pressed

        This property is \c true if the checkbox is pressed.
        Set this property to manually invoke a mouse click.
    */
    property alias pressed: behavior.effectivePressed

    /*!
        \qmlproperty bool checked

        This property is \c true if the checkbox is checked.
    */
    property alias checked: behavior.checked

    /*!
        \qmlproperty bool containsMouse

        This property is \c true if the checkbox currently contains the mouse
        cursor.
    */
    property alias containsMouse: behavior.containsMouse

    /*!
        This property is \c true if the checkbox takes the focus when it is
        pressed; \l{QQuickItem::forceActiveFocus()}{forceActiveFocus()} will be
        called on the checkbox.
    */
    property bool activeFocusOnPress: false

    property alias exclusiveGroup: behavior.exclusiveGroup

    /*!
        This property holds the text that the label should display.
    */
    property string text

    /*!
        \internal
    */
    property var styleHints:[]

    // implementation
    Accessible.role: Accessible.CheckBox
    Accessible.name: text

    implicitWidth: Math.max(120, loader.item ? loader.item.implicitWidth : 0)
    implicitHeight: loader.item ? loader.item.implicitHeight : 0

    /*!
        The style that should be applied to the checkbox. Custom style
        components can be created with:

        \codeline Qt.createComponent("path/to/style.qml", checkBoxId);
    */
    property Component style: Qt.createComponent(Settings.THEME_PATH + "/CheckBoxStyle.qml", checkBox)

    Loader {
        id: loader
        anchors.fill: parent
        property alias control: checkBox
        sourceComponent: style
    }

    ButtonBehavior {
        id: behavior
        focus: true
        property ExclusiveGroup exclusiveGroup
        anchors.fill: parent
        checkable: true
        onClicked: checkBox.clicked();
        onPressed: if (checkBox.activeFocusOnPress) checkBox.forceActiveFocus();
        onExclusiveGroupChanged: {
            if (exclusiveGroup)
                exclusiveGroup.registerCheckable(checkBox)
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Space && !event.isAutoRepeat && !behavior.pressed)
            behavior.keyPressed = true;
    }

    Keys.onReleased: {
        if (event.key == Qt.Key_Space && !event.isAutoRepeat && behavior.keyPressed) {
            behavior.keyPressed = false;
            checked = !checked;
            checkBox.clicked();
        }
    }
}
