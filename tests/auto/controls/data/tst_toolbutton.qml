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
import QtQuickControlsTests 1.0

Item {
    id: container
    width: 300
    height: 300

TestCase {
    id: testCase
    name: "Tests_ToolButton"
    when:windowShown
    width:400
    height:400

    function test_createToolButton() {
        var toolButton = Qt.createQmlObject('import QtQuick.Controls 1.2; ToolButton {}', testCase, '');
        toolButton.destroy()
    }

    function test_activeFocusOnPress(){
        var control = Qt.createQmlObject('import QtQuick.Controls 1.2; ToolButton {x: 20; y: 20; width: 100; height: 50}', container, '')
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
        if (Qt.styleHints.tabFocusBehavior != Qt.TabFocusAllControls)
            skip("This function doesn't support NOT iterating all.")

        var test_control = 'import QtQuick 2.2; \
        import QtQuick.Controls 1.2;            \
        Item {                                  \
            width: 200;                         \
            height: 200;                        \
            property alias control1: _control1; \
            property alias control2: _control2; \
            property alias control3: _control3; \
            ToolButton  {                       \
                y: 20;                          \
                id: _control1;                  \
                activeFocusOnTab: true;         \
                text: "control1"                \
            }                                   \
            ToolButton  {                       \
                y: 70;                          \
                id: _control2;                  \
                activeFocusOnTab: false;        \
                text: "control2"                \
            }                                   \
            ToolButton  {                       \
                y: 120;                         \
                id: _control3;                  \
                activeFocusOnTab: true;         \
                text: "control3"                \
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

    function test_checkableWithinExclusiveGroup_QTBUG31033() {
        var component = Qt.createComponent("toolbutton/tb_exclusivegroup.qml")
        compare(component.status, Component.Ready)
        var test =  component.createObject(container);
        verify(test !== null, "test control created is null")
        test.forceActiveFocus()
        verify(test.tb1.checked === false)
        verify(test.tb2.checked === false)
        mouseClick(test.tb1, 5, 5)
        verify(test.tb1.checked === true)
        verify(test.tb2.checked === false)
        mouseClick(test.tb2, 5, 5)
        verify(test.tb1.checked === false)
        verify(test.tb2.checked === true)
        mouseClick(test.tb2, 5, 5)
        verify(test.tb1.checked === false)
        verify(test.tb2.checked === true)
        test.destroy()
    }

    function test_checkableWithAction_QTBUG30971() {
        var component = Qt.createComponent("toolbutton/tb_withCheckableAction.qml")
        compare(component.status, Component.Ready)
        var test =  component.createObject(container);
        verify(test !== null, "test control created is null")
        test.forceActiveFocus()
        verify(test.tb.checked === false)
        verify(test.text1.isBold === false)
        verify(test.text2.isBold === false)
        mouseClick(test.text1, 5, 5)
        mouseClick(test.tb, 5, 5)
        verify(test.tb.checked === true)
        verify(test.text1.isBold === true)
        verify(test.text2.isBold === false)
        mouseClick(test.text2, 5, 5)
        verify(test.tb.checked === false)
        verify(test.text1.isBold === true)
        verify(test.text2.isBold === false)
        mouseClick(test.tb, 5, 5)
        verify(test.tb.checked === true)
        verify(test.text1.isBold === true)
        verify(test.text2.isBold === true)
        mouseClick(test.text1, 5, 5)
        mouseClick(test.tb, 5, 5)
        verify(test.tb.checked === false)
        verify(test.text1.isBold === false)
        verify(test.text2.isBold === true)
        test.destroy()
    }

    function test_checkableActionsWithinExclusiveGroup() {
        var component = Qt.createComponent("toolbutton/tb_checkableActionWithinExclusiveGroup.qml")
        compare(component.status, Component.Ready)
        var test = component.createObject(container);
        verify(test !== null, "test control created is null")
        test.forceActiveFocus()
        verify(test.tb1.checked === false)
        verify(test.tb2.checked === false)
        verify(test.text.isBold === false)
        verify(test.text.isUnderline === false)
        // clicking bold toolbutton
        mouseClick(test.tb1, 5, 5)
        verify(test.tb1.checked === true)
        verify(test.tb2.checked === false)
        verify(test.text.isBold === true)
        verify(test.text.isUnderline === false)
        // clicking in checked toolbutton does nothing
        mouseClick(test.tb1, 5, 5)
        verify(test.tb1.checked === true)
        verify(test.tb2.checked === false)
        verify(test.text.isBold === true)
        verify(test.text.isUnderline === false)
        // clicking underline toolbutton
        mouseClick(test.tb2, 5, 5)
        verify(test.tb1.checked === false)
        verify(test.tb2.checked === true)
        verify(test.text.isBold === false)
        verify(test.text.isUnderline === true)
        test.destroy()
    }
}
}

