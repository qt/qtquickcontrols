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
import QtQuick.Controls.Private 1.0

TestCase {
    id: testCase
    name: "Tests_Shortcut"
    when: windowShown
    width: 400
    height: 400

    property var rootObject

    function initTestCase() {
        var component = Qt.createComponent("shortcut/shortcuts.qml");
        compare(component.status, Component.Ready)
        rootObject =  component.createObject(testCase);
        verify(rootObject !== null, "created object is null")
        rootObject.forceActiveFocus();
    }

    function cleanup() {
        if (rootObject !== null)
            rootObject.destroy()
    }

    function test_shortcut_data() {
        return [
            { tag: "a_pressed", key: Qt.Key_A, modifier: Qt.NoModifier, expected: "a pressed" },
            { tag: "b_pressed", key: Qt.Key_B, modifier: Qt.NoModifier, expected: "b pressed" },
            { tag: "nokey_pressed1", key: Qt.Key_C, modifier: Qt.NoModifier, expected: "no key press" },
            { tag: "ctrlc_pressed", key: Qt.Key_C, modifier: Qt.ControlModifier, expected: "ctrl c pressed" },
            { tag: "dpressed", key: Qt.Key_D, modifier: Qt.NoModifier, expected: "d pressed" },
            { tag: "nokey_pressed2", key: Qt.Key_D, modifier: Qt.ControlModifier, expected: "no key press" },
            // shift d is not triggered because it is overloaded
            { tag: "overloaded", key: Qt.Key_D, modifier: Qt.ShiftModifier, expected: "no key press",
                        warning: "QQuickAction::event: Ambiguous shortcut overload: Shift+D" },
            { tag: "aldd_pressed", key: Qt.Key_D, modifier: Qt.AltModifier, expected: "alt d pressed" },
            { tag: "nokey_pressed3", key: Qt.Key_T, modifier: Qt.NoModifier, expected: "no key press" },
            // on mac we don't have mnemonics
            { tag: "mnemonics", key: Qt.Key_T, modifier: Qt.AltModifier, expected: Qt.platform.os === "osx" ? "no key press" : "alt t pressed" },
            { tag: "checkbox", key: Qt.Key_C, modifier: Qt.AltModifier, expected: Qt.platform.os === "osx" ? "no key press" : "alt c pressed" },
            { tag: "radiobutton", key: Qt.Key_R, modifier: Qt.AltModifier, expected: Qt.platform.os === "osx" ? "no key press" : "alt r pressed" },
            { tag: "button", key: Qt.Key_1, modifier: Qt.AltModifier, expected: Qt.platform.os === "osx" ? "no key press" : "alt 1 pressed" },
            { tag: "button+action", key: Qt.Key_2, modifier: Qt.AltModifier, expected: Qt.platform.os === "osx" ? "no key press" : "alt 2 pressed" },
            { tag: "toolbutton", key: Qt.Key_3, modifier: Qt.AltModifier, expected: Qt.platform.os === "osx" ? "no key press" : "alt 3 pressed" },
            { tag: "toolbutton+action", key: Qt.Key_4, modifier: Qt.AltModifier, expected: Qt.platform.os === "osx" ? "no key press" : "alt 4 pressed" },
        ]
    }

    function test_shortcut(data) {

        verify(rootObject != undefined);
        var text = rootObject.children[0];
        text.text = "no key press";

        if (data.warning !== undefined) {
            if (Qt.platform.os === "osx" && data.tag === "overloaded")
                ignoreWarning("QQuickAction::event: Ambiguous shortcut overload: ?D") // QTBUG_32089
            else
                ignoreWarning(data.warning)
        }
        keyPress(data.key, data.modifier);

        verify(text != undefined);
        compare(text.text, data.expected.toString());

    }
}



