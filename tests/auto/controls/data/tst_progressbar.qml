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
    name: "Tests_ProgressBar"
    when:windowShown
    width:400
    height:400

    function test_minimumvalue() {
        var progressBar = Qt.createQmlObject('import QtQuick.Controls 1.2; ProgressBar {}', testCase, '');

        progressBar.minimumValue = 5
        progressBar.maximumValue = 10
        progressBar.value = 2
        compare(progressBar.minimumValue, 5)
        compare(progressBar.value, 5)

        progressBar.minimumValue = 7
        compare(progressBar.value, 7)
        progressBar.destroy()
    }

    function test_maximumvalue() {
        var progressBar = Qt.createQmlObject('import QtQuick.Controls 1.2; ProgressBar {}', testCase, '');

        progressBar.minimumValue = 5
        progressBar.maximumValue = 10
        progressBar.value = 15
        compare(progressBar.maximumValue, 10)
        compare(progressBar.value, 10)

        progressBar.maximumValue = 8
        compare(progressBar.value, 8)
        progressBar.destroy()
    }

    function test_invalidMinMax() {
        var progressBar = Qt.createQmlObject('import QtQuick.Controls 1.2; ProgressBar {}', testCase, '');

        // minimumValue has priority over maximum if they are inconsistent

        progressBar.minimumValue = 10
        progressBar.maximumValue = 10
        compare(progressBar.value, progressBar.minimumValue)

        progressBar.value = 17
        compare(progressBar.value, progressBar.minimumValue)

        progressBar.maximumValue = 5
        compare(progressBar.value, progressBar.minimumValue)

        progressBar.value = 12
        compare(progressBar.value, progressBar.minimumValue)

        var progressBar2 = Qt.createQmlObject('import QtQuick.Controls 1.2; ProgressBar {minimumValue: 10; maximumValue: 4; value: 5}', testCase, '');
        compare(progressBar.value, progressBar.minimumValue)
        progressBar.destroy()
        progressBar2.destroy()
    }

    function test_initialization_order()
    {
        var progressBar = Qt.createQmlObject("import QtQuick.Controls 1.2; ProgressBar {maximumValue: 100; value: 50}",
                                         testCase, '')
        compare(progressBar.value, 50);

        var progressBar2 = Qt.createQmlObject("import QtQuick.Controls 1.2; ProgressBar {" +
                                         "value: 50; maximumValue: 100}",
                                         testCase, '')
        compare(progressBar2.value, 50);

        var progressBar3 = Qt.createQmlObject("import QtQuick.Controls 1.2; ProgressBar { minimumValue: -50 ; value:-10}",
                                         testCase, '')
        compare(progressBar3.value, -10);

        var progressBar4 = Qt.createQmlObject("import QtQuick.Controls 1.2; ProgressBar { value:-10; minimumValue: -50}",
                                         testCase, '')
        compare(progressBar4.value, -10);
        progressBar.destroy()
        progressBar2.destroy()
        progressBar3.destroy()
        progressBar4.destroy()
    }

    function test_activeFocusOnTab() {
        if (!SystemInfo.tabAllWidgets)
            skip("This function doesn't support NOT iterating all.")

        var test_control = 'import QtQuick 2.2; \
        import QtQuick.Controls 1.2;            \
        Item {                                  \
            width: 200;                         \
            height: 200;                        \
            property alias control1: _control1; \
            property alias control2: _control2; \
            property alias control3: _control3; \
            ProgressBar  {                      \
                y: 20;                          \
                id: _control1;                  \
                activeFocusOnTab: true;         \
            }                                   \
            ProgressBar  {                      \
                y: 70;                          \
                id: _control2;                  \
                activeFocusOnTab: false;        \
            }                                   \
            ProgressBar  {                      \
                y: 120;                         \
                id: _control3;                  \
                activeFocusOnTab: true;         \
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
