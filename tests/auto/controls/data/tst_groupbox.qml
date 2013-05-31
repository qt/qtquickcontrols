/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
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

import QtQuick 2.1
import QtTest 1.0
import QtQuick.Controls 1.0
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

        var groupbox = Qt.createQmlObject('import QtQuick.Controls 1.0; import QtQuick.Controls.Styles.Private 1.0 ; GroupBox {style:GroupBoxStyle{}}', container, '')
        compare(groupbox.width, 16)
        compare(groupbox.height, 16)

        var content = Qt.createQmlObject('import QtQuick 2.1; Rectangle {implicitWidth:100 ; implicitHeight:30}', container, '')
        content.parent = groupbox.contentItem
        compare(groupbox.implicitWidth, 116)
        compare(groupbox.implicitHeight, 46)
        content.parent = null
        content.destroy()

        content = Qt.createQmlObject('import QtQuick 2.1; Rectangle {width:20 ; height:20}', container, '')
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

        var test_control = 'import QtQuick 2.1; \
        import QtQuick.Controls 1.0;            \
        Item {                                  \
            width: 200;                         \
            height: 200;                        \
            property alias control1: _control1; \
            property alias control2: _control2; \
            property alias control3: _control3; \
            GroupBox  {                         \
                y: 20;                          \
                id: _control1;                  \
                activeFocusOnTab: true;         \
                title: "control1"               \
            }                                   \
            GroupBox  {                         \
                y: 70;                          \
                id: _control2;                  \
                activeFocusOnTab: false;        \
                title: "control2"               \
            }                                   \
            GroupBox  {                         \
                y: 120;                         \
                id: _control3;                  \
                activeFocusOnTab: true;         \
                title: "control3"               \
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
}
}
