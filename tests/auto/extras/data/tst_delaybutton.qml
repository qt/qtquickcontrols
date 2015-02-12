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

import QtTest 1.0
import QtQuick 2.1

TestCase {
    id: testcase
    name: "Tests_DelayButton"
    visible: windowShown
    when: windowShown
    width: 400
    height: 400

    function test_instance() {
        var button = Qt.createQmlObject('import QtQuick.Extras 1.3; DelayButton { }', testcase, '')
        verify (button, "DelayButton: failed to create an instance")
        verify(button.__style)
        verify(!button.checked)
        verify(!button.pressed)
        button.destroy()
    }

    SignalSpy {
        id: activationSpy
        signalName: "activated"
    }

    function test_activation_data() {
        return [
            { tag: "delayed", delay: 1 },
            { tag: "immediate", delay: 0 },
            { tag: "negative", delay: -1 }
        ]
    }

    function test_activation(data) {
        var button = Qt.createQmlObject('import QtQuick.Extras 1.3; DelayButton { }', testcase, '')
        verify (button, "DelayButton: failed to create an instance")
        button.delay = data.delay

        activationSpy.clear()
        activationSpy.target = button
        verify(activationSpy.valid)

        // press and hold to activate
        mousePress(button, button.width / 2, button.height / 2)
        verify(button.pressed)
        var immediate = data.delay <= 0
        if (!immediate)
            activationSpy.wait()
        compare(activationSpy.count, 1)

        // release
        mouseRelease(button, button.width / 2, button.height / 2)
        verify(!button.pressed)
        compare(activationSpy.count, 1)

        button.destroy()
    }

    SignalSpy {
        id: progressSpy
        signalName: "progressChanged"
    }

    function test_progress() {
        var button = Qt.createQmlObject('import QtQuick.Extras 1.3; DelayButton { delay: 1 }', testcase, '')
        verify (button, "DelayButton: failed to create an instance")

        progressSpy.target = button
        verify(progressSpy.valid)

        compare(button.progress, 0.0)
        mousePress(button, button.width / 2, button.height / 2)
        tryCompare(button, "progress", 1.0)
        verify(progressSpy.count > 0)

        button.destroy()
    }

    SignalSpy {
        id: checkSpy
        signalName: "checkedChanged"
    }

    function test_checked_data() {
        return [
            { tag: "delayed", delay: 1 },
            { tag: "immediate", delay: 0 },
            { tag: "negative", delay: -1 }
        ]
    }

    function test_checked(data) {
        var button = Qt.createQmlObject('import QtQuick.Extras 1.3; DelayButton { }', testcase, '')
        verify (button, "DelayButton: failed to create an instance")
        button.delay = data.delay

        var checkCount = 0

        checkSpy.clear()
        checkSpy.target = button
        verify(checkSpy.valid)
        verify(!button.checked)

        // press and hold to check
        mousePress(button, button.width / 2, button.height / 2)
        verify(button.pressed)
        var immediate = data.delay <= 0
        compare(button.checked, immediate)
        if (!immediate)
            tryCompare(button, "checked", true)
        compare(checkSpy.count, ++checkCount)

        // release
        mouseRelease(button, button.width / 2, button.height / 2)
        verify(!button.pressed)
        verify(button.checked)
        compare(checkSpy.count, checkCount)

        // press to uncheck immediately
        mousePress(button, button.width / 2, button.height / 2)
        verify(button.pressed)
        verify(!button.checked)
        compare(checkSpy.count, ++checkCount)

        // release
        mouseRelease(button, button.width / 2, button.height / 2)
        verify(!button.pressed)
        verify(!button.checked)
        compare(checkSpy.count, checkCount)

        button.destroy()
    }

    function test_programmaticCheck() {
        var button = Qt.createQmlObject("import QtQuick.Extras 1.3; DelayButton {}", testcase, "");
        verify(button, "DelayButton: failed to create an instance");

        checkSpy.clear();
        checkSpy.target = button;
        verify(!button.checked);

        button.checked = true;
        compare(button.progress, 1);

        button.checked = false;
        compare(button.progress, 0);

        button.destroy();
    }

    function test_largeText() {
        // Should be no binding loop warnings.
        var button = Qt.createQmlObject("import QtQuick.Extras 1.3; DelayButton { "
            + "anchors.centerIn: parent; text: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' }", testcase, "");
        verify(button, "DelayButton: failed to create an instance");
        button.destroy();
    }
}
