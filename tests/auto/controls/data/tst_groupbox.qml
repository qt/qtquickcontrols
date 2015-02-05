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
import QtQuick.Controls 1.2
import QtQuickControlsTests 1.0

Item {
    id: container
    width: 400
    height: 400

TestCase {
    id: testCase
    name: "Tests_GroupBox"
    when:windowShown
    width:400
    height:400

    property var groupBox;

    Component {
        id: groupboxComponent
        GroupBox {
            property alias child1: child1
            property alias child2: child2
            Column {
                CheckBox {
                    id: child1
                    text: "checkbox1"
                }
                CheckBox {
                    id: child2
                    text: "checkbox2"
                }
            }
        }
    }

    function init() {
        groupBox = groupboxComponent.createObject(testCase)
    }

    function cleanup() {
        if (groupBox !== 0)
            groupBox.destroy()
    }

    function test_contentItem() {
        verify (groupBox.contentItem !== null)
        verify (groupBox.contentItem.anchors !== undefined)
    }

    function test_dynamicSize() {

        var groupbox = Qt.createQmlObject('import QtQuick.Controls 1.2; import QtQuick.Controls.Private 1.0 ; GroupBox {style:GroupBoxStyle{}}', container, '')
        compare(groupbox.width, 16)
        compare(groupbox.height, 16)

        var content = Qt.createQmlObject('import QtQuick 2.2; Rectangle {implicitWidth:100 ; implicitHeight:30}', container, '')
        content.parent = groupbox.contentItem
        compare(groupbox.implicitWidth, 116)
        compare(groupbox.implicitHeight, 46)
        content.parent = null
        content.destroy()

        content = Qt.createQmlObject('import QtQuick 2.2; Rectangle {width:20 ; height:20}', container, '')
        content.parent = groupbox.contentItem
        compare(groupbox.implicitWidth, 36)
        compare(groupbox.implicitHeight, 36)
        content.parent = null
        content.destroy()

        groupbox.destroy()
    }

    function test_checkable() {
        compare(groupBox.checkable, false)
        compare(groupBox.child1.enabled, true)
        compare(groupBox.child2.enabled, true)

        groupBox.checkable = true
        compare(groupBox.checkable, true)
        compare(groupBox.checked, true)
        compare(groupBox.child1.enabled, true)
        compare(groupBox.child2.enabled, true)

        groupBox.checkable = false
        compare(groupBox.child1.enabled, true)
        compare(groupBox.child2.enabled, true)
    }

    function test_checked() {
        groupBox.checkable = true
        groupBox.checked = false
        compare(groupBox.checked, false)
        compare(groupBox.child1.enabled, false)
        compare(groupBox.child2.enabled, false)

        groupBox.checked = true
        compare(groupBox.checked, true)
        compare(groupBox.child1.enabled, true)
        compare(groupBox.child2.enabled, true)
    }

    function test_activeFocusOnTab() {
        if (!SystemInfo.tabAllWidgets)
            skip("This function doesn't support NOT iterating all.")

        var component = Qt.createComponent("groupbox/gb_activeFocusOnTab.qml")
        compare(component.status, Component.Ready)
        var control =  component.createObject(container);
        verify(control !== null, "test control created is null")

        var gp1 = control.control1
        var gp2 = control.control2
        verify(gp1 !== null)
        verify(gp2 !== null)

        var check = getCheckBoxItem(gp1)
        verify(check !== null)

        var column1 = getColumnItem(gp1, "column1")
        verify(column1 !== null)
        var column2 = getColumnItem(gp2, "column2")
        verify(column2 !== null)

        var child1 = column1.child1
        verify(child1 !== null)
        var child2 = column1.child2
        verify(child2 !== null)
        var child3 = column2.child3
        verify(child3 !== null)
        var child4 = column2.child4
        verify(child4 !== null)

        control.forceActiveFocus()
        keyPress(Qt.Key_Tab)
        verify(check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(!check.activeFocus)
        verify(child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(!check.activeFocus)
        verify(!child1.activeFocus)
        verify(child2.activeFocus)
        verify(!child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(!check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(!check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(child4.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(child4.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!check.activeFocus)
        verify(!child1.activeFocus)
        verify(child2.activeFocus)
        verify(!child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!check.activeFocus)
        verify(child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(!child4.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!check.activeFocus)
        verify(!child1.activeFocus)
        verify(!child2.activeFocus)
        verify(!child3.activeFocus)
        verify(child4.activeFocus)

        control.destroy()
    }

    function getCheckBoxItem(control) {
        for (var i = 0; i < control.children.length; i++) {
            if (control.children[i].objectName === 'check')
                return control.children[i]
        }
        return null
    }

    function getColumnItem(control, name) {
        for (var i = 0; i < control.children.length; i++) {
            if (control.children[i].objectName === 'container') {
                var sub = control.children[i]
                for (var j = 0; j < sub.children.length; j++) {
                    if (sub.children[j].objectName === name)
                        return sub.children[j]
                }
            }
        }
        return null
    }
}
}
