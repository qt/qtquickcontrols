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
    width: 400
    height: 400

    TestCase {
        id: testCase
        name: "Tests_RadioButton"
        when: windowShown
        width: 400
        height: 400

        property var radioButton

        SignalSpy {
            id: signalSpy
        }

        function init() {
            radioButton = Qt.createQmlObject('import QtQuick.Controls 1.2; RadioButton {}', container, '');
        }

        function cleanup() {
            if (radioButton !== null) {
                radioButton.destroy()
            }
            signalSpy.clear();
        }

        function test_createRadioButton() {
            compare(radioButton.checked, false);
            compare(radioButton.text, "");
        }

        function test_defaultConstructed() {
            compare(radioButton.checked, false);
            compare(radioButton.text, "");
        }

        function test_text() {
            compare(radioButton.text, "");

            radioButton.text = "Check me!";
            compare(radioButton.text, "Check me!");
        }

        function test_checked() {
            compare(radioButton.checked, false);

            radioButton.checked = true;
            compare(radioButton.checked, true);

            radioButton.checked = false;
            compare(radioButton.checked, false);
        }

        function test_clicked() {
            signalSpy.signalName = "clicked"
            signalSpy.target = radioButton;
            compare(signalSpy.count, 0);
            mouseClick(radioButton, radioButton.x, radioButton.y, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(radioButton.checked, true);

            // Clicking outside should do nothing.
            mouseClick(radioButton, radioButton.x - 1, radioButton.y, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(radioButton.checked, true);

            mouseClick(radioButton, radioButton.x, radioButton.y - 1, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(radioButton.checked, true);

            mouseClick(radioButton, radioButton.x - 1, radioButton.y - 1, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(radioButton.checked, true);
        }

        function test_keyPressed() {
            radioButton.forceActiveFocus();

            signalSpy.signalName = "clicked";
            signalSpy.target = radioButton;
            compare(signalSpy.count, 0);

            // Try cycling through checked and unchecked.
            var expectedStates = [true, false];
            expectedStates = expectedStates.concat(expectedStates, expectedStates, expectedStates);
            for (var i = 0; i < expectedStates.length; ++i) {
                keyPress(Qt.Key_Space);
                keyRelease(Qt.Key_Space);
                compare(signalSpy.count, i + 1);
                compare(radioButton.checked, expectedStates[i]);
            }
        }

        function test_exclusiveGroup() {
            var root = Qt.createQmlObject("import QtQuick 2.2; import QtQuick.Controls 1.2; \n"
                + "Row { \n"
                + "    property alias radioButton1: radioButton1 \n"
                + "    property alias radioButton2: radioButton2 \n"
                + "    property alias group: group \n"
                + "    ExclusiveGroup { id: group } \n"
                + "    RadioButton { id: radioButton1; checked: true; exclusiveGroup: group } \n"
                + "    RadioButton { id: radioButton2; exclusiveGroup: group } \n"
                + "}", container, "");

            compare(root.radioButton1.exclusiveGroup, root.group);
            compare(root.radioButton2.exclusiveGroup, root.group);
            compare(root.radioButton1.checked, true);
            compare(root.radioButton2.checked, false);

            root.forceActiveFocus();

            signalSpy.target = root.radioButton2;
            signalSpy.signalName = "clicked";
            compare(signalSpy.count, 0);

            mouseClick(root.radioButton2, root.radioButton2.x, root.radioButton2.y, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(root.radioButton1.checked, false);
            compare(root.radioButton2.checked, true);

            signalSpy.clear();
            signalSpy.target = root.radioButton1;
            signalSpy.signalName = "clicked";
            compare(signalSpy.count, 0);

            mouseClick(root.radioButton1, root.radioButton1.x, root.radioButton1.y, Qt.LeftButton);
            compare(signalSpy.count, 1);
            compare(root.radioButton1.checked, true);
            compare(root.radioButton2.checked, false);
            root.destroy()
        }

        function test_activeFocusOnPress(){
            radioButton.activeFocusOnPress = false
            verify(!radioButton.activeFocus)
            mouseClick(radioButton, radioButton.x + 1, radioButton.y + 1)
            verify(!radioButton.activeFocus)
            radioButton.activeFocusOnPress = true
            verify(!radioButton.activeFocus)
            mouseClick(radioButton, radioButton.x + 1, radioButton.y + 1)
            verify(radioButton.activeFocus)
        }

        function test_activeFocusOnTab() {
            radioButton.destroy()
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
                RadioButton  {                      \
                    y: 20;                          \
                    id: _control1;                  \
                    activeFocusOnTab: true;         \
                    text: "control1"                \
                }                                   \
                RadioButton  {                      \
                    y: 70;                          \
                    id: _control2;                  \
                    activeFocusOnTab: false;        \
                    text: "control2"                \
                }                                   \
                RadioButton  {                      \
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
