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

import QtQuick 2.0
import QtTest 1.0

Item {
    id: container

    TestCase {
        id: testCase
        name: "Tests_CheckBox"
        when: windowShown
        width: 50
        height: 50

        property var checkBox

        SignalSpy {
            id: signalSpy
        }

        function init() {
            checkBox = Qt.createQmlObject("import QtDesktop 1.0; CheckBox { }", container, "");
        }

        function cleanup() {
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
    }
}
