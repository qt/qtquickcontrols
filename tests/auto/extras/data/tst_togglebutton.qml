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
    name: "Tests_ToggleButton"
    visible: windowShown
    when: windowShown
    width: 400
    height: 400

    function test_instance() {
        var button = Qt.createQmlObject('import QtQuick.Extras 1.4; ToggleButton { }', testcase, '');
        verify (button, "ToggleButton: failed to create an instance")
        verify(button.__style)
        verify(button.checkable)
        verify(!button.checked)
        verify(!button.pressed)
        button.destroy()
    }

    function test_largeText() {
        // Should be no binding loop warnings.
        var button = Qt.createQmlObject("import QtQuick.Extras 1.4; ToggleButton { "
            + "anchors.centerIn: parent; text: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' }", testcase, "");
        verify(button, "ToggleButton: failed to create an instance");
        waitForRendering(button);
    }
}
