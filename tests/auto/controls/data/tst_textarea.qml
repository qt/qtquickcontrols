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
import QtTest 1.0

Item {
    id: container
    width: 300
    height: 300

TestCase {
    id: testCase
    name: "Tests_TextArea"
    when: windowShown
    width: 400
    height: 400

    function test_append() {
        var textarea = Qt.createQmlObject('import QtQuick.Controls 1.2; TextArea {}', testCase, '')

        compare(textarea.text, "")

        textarea.append("my")
        compare(textarea.text, "my")

        textarea.append("name");
        compare(textarea.text, "my\nname")
        textarea.destroy()
    }

    function test_activeFocusOnPress(){
        var control = Qt.createQmlObject('import QtQuick.Controls 1.2; TextArea {x: 20; y: 20; width: 100; height: 50}', container, '')
        control.activeFocusOnPress = false
        verify(!control.activeFocus)
        mouseClick(control, 30, 30)
        verify(!control.activeFocus)
        control.activeFocusOnPress = true
        verify(!control.activeFocus)
        mouseClick(control, 30, 30)
        verify(control.activeFocus)
        control.destroy()
    }

    function test_activeFocusOnTab() {
        // Set TextArea readonly so the tab/backtab can be tested toward the navigation
        var test_control = 'import QtQuick 2.2; \
        import QtQuick.Controls 1.2;            \
        Item {                                  \
            width: 200;                         \
            height: 200;                        \
            property alias control1: _control1; \
            property alias control2: _control2; \
            property alias control3: _control3; \
            TextArea  {                         \
                y: 20;                          \
                id: _control1;                  \
                activeFocusOnTab: true;         \
                text: "control1";               \
                readOnly: true                  \
            }                                   \
            TextArea  {                         \
                y: 70;                          \
                id: _control2;                  \
                activeFocusOnTab: false;        \
                text: "control2";               \
                readOnly: true                  \
            }                                   \
            TextArea  {                         \
                y: 120;                         \
                id: _control3;                  \
                activeFocusOnTab: true;         \
                text: "control3";               \
                readOnly: true                  \
            }                                   \
        }                                       '

        var control = Qt.createQmlObject(test_control, container, '')

        control.control1.forceActiveFocus()
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(!control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(control.control3.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)

        control.control2.activeFocusOnTab = true
        control.control3.activeFocusOnTab = false
        keyPress(Qt.Key_Tab)
        verify(!control.control1.activeFocus)
        verify(control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!control.control1.activeFocus)
        verify(control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        control.destroy()
    }

    function test_editingFinished() {
        var component = Qt.createComponent("textarea/ta_editingfinished.qml")
        compare(component.status, Component.Ready)
        var test =  component.createObject(container);
        verify(test !== null, "test control created is null")
        var control1 = test.control1
        verify(control1 !== null)
        var control2 = test.control2
        verify(control2 !== null)

        control1.forceActiveFocus()
        verify(control1.activeFocus)
        verify(!control2.activeFocus)

        verify(control1.myeditingfinished === false)
        verify(control2.myeditingfinished === false)

        keyPress(Qt.Key_Backtab)
        verify(!control1.activeFocus)
        verify(control2.activeFocus)
        verify(control1.myeditingfinished === true)

        keyPress(Qt.Key_Backtab)
        verify(control1.activeFocus)
        verify(!control2.activeFocus)
        verify(control2.myeditingfinished === true)

        test.destroy()
    }

    function test_keys() {
        var component = Qt.createComponent("textarea/ta_keys.qml")
        compare(component.status, Component.Ready)
        var test =  component.createObject(container);
        verify(test !== null, "test control created is null")
        var control1 = test.control1
        verify(control1 !== null)

        control1.forceActiveFocus()
        verify(control1.activeFocus)

        verify(control1.gotit === false)
        verify(control1.text === "")

        keyPress(Qt.Key_A)
        verify(control1.activeFocus)
        verify(control1.gotit === false)
        verify(control1.text === "a")

        keyPress(Qt.Key_B)
        verify(control1.activeFocus)
        verify(control1.gotit === true)
        verify(control1.text === "a")

        keyPress(Qt.Key_B)
        verify(control1.activeFocus)
        verify(control1.gotit === true)
        verify(control1.text === "ab")

        test.destroy()
    }
}
}
