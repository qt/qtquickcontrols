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
    width: 200
    height: 200

    TestCase {
        id: testCase
        name: "Tests_CheckBox"
        when: windowShown
        width: 200
        height: 200

        property var checkBox

        SignalSpy {
            id: signalSpy
        }

        function init() {
            checkBox = Qt.createQmlObject("import QtQuick.Controls 1.2; CheckBox { }", container, "");
        }

        function cleanup() {
            if (checkBox !== null) {
                checkBox.destroy()
            }
            signalSpy.clear();
        }

        function test_defaultConstructed() {
            compare(checkBox.checked, false);
            compare(checkBox.checkedState, Qt.Unchecked);
            compare(checkBox.partiallyCheckedEnabled, false);
            compare(checkBox.text, "");
        }

        function test_text() {
            compare(checkBox.text, "");

            checkBox.text = "Check me!";
            compare(checkBox.text, "Check me!");
        }

        function test_checked() {
            compare(checkBox.checked, false);
            compare(checkBox.checkedState, Qt.Unchecked);
            compare(checkBox.partiallyCheckedEnabled, false);

            checkBox.checked = true;
            compare(checkBox.checked, true);
            compare(checkBox.checkedState, Qt.Checked);
            compare(checkBox.partiallyCheckedEnabled, false);

            checkBox.checkedState = Qt.Unchecked;
            compare(checkBox.checked, false);
            compare(checkBox.checkedState, Qt.Unchecked);
            compare(checkBox.partiallyCheckedEnabled, false);

            checkBox.checkedState = Qt.Checked;
            compare(checkBox.checked, true);
            compare(checkBox.checkedState, Qt.Checked);
            compare(checkBox.partiallyCheckedEnabled, false);

            checkBox.checkedState = Qt.PartiallyChecked;
            compare(checkBox.checked, false);
            compare(checkBox.checkedState, Qt.PartiallyChecked);
            compare(checkBox.partiallyCheckedEnabled, true);
        }

        function test_clicked() {
            signalSpy.signalName = "clicked"
            signalSpy.target = checkBox;
            compare(signalSpy.count, 0);
            mouseClick(checkBox, checkBox.x + 1, checkBox.y + 1, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(checkBox.checked, true);
            compare(checkBox.checkedState, Qt.Checked);

            // Clicking outside should do nothing.
            mouseClick(checkBox, checkBox.x - 1, checkBox.y, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(checkBox.checked, true);

            mouseClick(checkBox, checkBox.x, checkBox.y - 1, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(checkBox.checked, true);

            mouseClick(checkBox, checkBox.x - 1, checkBox.y - 1, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(checkBox.checked, true);
        }

        function test_keyPressed() {
            checkBox.forceActiveFocus();

            signalSpy.signalName = "clicked";
            signalSpy.target = checkBox;
            compare(signalSpy.count, 0);

            // Try cycling through checked and unchecked.
            var expectedStates = [Qt.Checked, Qt.Unchecked];
            expectedStates = expectedStates.concat(expectedStates, expectedStates, expectedStates);
            for (var i = 0; i < expectedStates.length; ++i) {
                keyPress(Qt.Key_Space);
                keyRelease(Qt.Key_Space);
                compare(signalSpy.count, i + 1);
                compare(checkBox.checkedState, expectedStates[i]);
                compare(checkBox.checked, checkBox.checkedState === Qt.Checked);
            }

            // Try cycling through all three states.
            checkBox.partiallyCheckedEnabled = true;
            compare(checkBox.checkedState, Qt.Unchecked);
            compare(checkBox.checked, false);

            signalSpy.clear();
            expectedStates = [Qt.Checked, Qt.PartiallyChecked, Qt.Unchecked];
            expectedStates = expectedStates.concat(expectedStates, expectedStates, expectedStates);
            for (i = 0; i < expectedStates.length; ++i) {
                keyPress(Qt.Key_Space);
                keyRelease(Qt.Key_Space);
                compare(signalSpy.count, i + 1);
                compare(checkBox.checkedState, expectedStates[i]);
            }
        }

        function test_check_keep_binding() {
            var root = Qt.createQmlObject("import QtQuick 2.2; import QtQuick.Controls 1.2; \n"
                + "Row { \n"
                + "    property alias checkBox1: checkBox1 \n"
                + "    property alias checkBox2: checkBox2 \n"
                + "    CheckBox { id: checkBox1 } \n"
                + "    CheckBox { id: checkBox2; checked: checkBox1.checked; enabled: false } \n"
                + "}", container, "");

            compare(root.checkBox1.checked, false);
            compare(root.checkBox2.checked, false);
            root.checkBox1.checked = true;
            compare(root.checkBox1.checked, true);
            compare(root.checkBox2.checked, true);
            root.checkBox1.checked = false;
            compare(root.checkBox1.checked, false);
            compare(root.checkBox2.checked, false);
        }

        function test_checkState_keep_binding() {
            var root = Qt.createQmlObject("import QtQuick 2.2; import QtQuick.Controls 1.2; \n"
                + "Row { \n"
                + "    property alias checkBox1: checkBox1 \n"
                + "    property alias checkBox2: checkBox2 \n"
                + "    CheckBox { id: checkBox1 } \n"
                + "    CheckBox { id: checkBox2; checkedState: checkBox1.checkedState; enabled: false } \n"
                + "}", container, "");

            compare(root.checkBox1.checkedState, Qt.Unchecked);
            compare(root.checkBox2.checkedState, Qt.Unchecked);
            root.checkBox1.checkedState = Qt.Checked;
            compare(root.checkBox1.checkedState, Qt.Checked);
            compare(root.checkBox2.checkedState, Qt.Checked);
            root.checkBox1.checkedState = Qt.Unchecked;
            compare(root.checkBox1.checkedState, Qt.Unchecked);
            compare(root.checkBox2.checkedState, Qt.Unchecked);
        }


        function test_exclusiveGroup() {
            var root = Qt.createQmlObject("import QtQuick 2.2; import QtQuick.Controls 1.2; \n"
                + "Row { \n"
                + "    property alias checkBox1: checkBox1 \n"
                + "    property alias checkBox2: checkBox2 \n"
                + "    property alias group: group \n"
                + "    ExclusiveGroup { id: group } \n"
                + "    CheckBox { id: checkBox1; checked: true; exclusiveGroup: group } \n"
                + "    CheckBox { id: checkBox2; exclusiveGroup: group } \n"
                + "}", container, "");

            compare(root.checkBox1.exclusiveGroup, root.group);
            compare(root.checkBox2.exclusiveGroup, root.group);
            compare(root.checkBox1.checked, true);
            compare(root.checkBox2.checked, false);

            root.forceActiveFocus();

            signalSpy.target = root.checkBox2;
            signalSpy.signalName = "clicked";
            compare(signalSpy.count, 0);

            mouseClick(root.checkBox2, root.checkBox2.x, root.checkBox2.y, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(root.checkBox1.checked, false);
            compare(root.checkBox2.checked, true);

            signalSpy.clear();
            signalSpy.target = root.checkBox1;
            signalSpy.signalName = "clicked";
            compare(signalSpy.count, 0);

            mouseClick(root.checkBox1, root.checkBox1.x, root.checkBox1.y, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(root.checkBox1.checked, true);
            compare(root.checkBox2.checked, false);

            ignoreWarning("Cannot have partially checked boxes in an ExclusiveGroup.");
            root.checkBox1.partiallyCheckedEnabled = true;
            ignoreWarning("Cannot have partially checked boxes in an ExclusiveGroup.");
            root.checkBox2.partiallyCheckedEnabled = true;

            // Shouldn't be any warnings, since we're not setting a group.
            root.checkBox1.exclusiveGroup = null;
            root.checkBox2.exclusiveGroup = null;

            ignoreWarning("Cannot have partially checked boxes in an ExclusiveGroup.");
            root.checkBox1.exclusiveGroup = root.group;
            ignoreWarning("Cannot have partially checked boxes in an ExclusiveGroup.");
            root.checkBox2.exclusiveGroup = root.group;

            // Shouldn't be any warnings, since we're not setting partiallyCheckedEnabled to true.
            root.checkBox1.partiallyCheckedEnabled = false;
            root.checkBox2.partiallyCheckedEnabled = false;
        }

        function test_activeFocusOnPress(){
            checkBox.activeFocusOnPress = false
            verify(!checkBox.activeFocus)
            mouseClick(checkBox, checkBox.x + 1, checkBox.y + 1)
            verify(!checkBox.activeFocus)
            checkBox.activeFocusOnPress = true
            verify(!checkBox.activeFocus)
            mouseClick(checkBox, checkBox.x + 1, checkBox.y + 1)
            verify(checkBox.activeFocus)
        }

        function test_activeFocusOnTab() {
            checkBox.destroy()
            wait(0) //QTBUG-30523 so processEvents is called

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
                CheckBox  {                         \
                    y: 20;                          \
                    id: _control1;                  \
                    activeFocusOnTab: true;         \
                    text: "control1"                \
                }                                   \
                CheckBox  {                         \
                    y: 70;                          \
                    id: _control2;                  \
                    activeFocusOnTab: false;        \
                    text: "control2"                \
                }                                   \
                CheckBox  {                         \
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
    }
}
